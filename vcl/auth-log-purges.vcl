sub vcl_recv {
  if(req.request == "FASTLYPURGE" || req.request == "PURGE") {
    if (!req.http.Cookie ~ "username=.*" || ! req.http.Auth ~ "(this|that)") {
      error 666 "Not allowed to purge";
    } else {
      log {"syslog 5Z5XgjeAodFNnNixo8LskA jdade.me.uk :: "} now {" "} req.http.Fastly-Client-IP {" "} req.request {" "} time.elapsed.msec {" "} server.port {" "} req.proto {" "} req.http.User-agent {" "} req.http.Cookie {" "} req.http.Referer;
      return(lookup);
    }
  }
#FASTLY recv

    if (req.request != "HEAD" && req.request != "GET" && req.request != "FASTLYPURGE") {
      return(pass);
    }

    return(lookup);
}

sub vcl_fetch {
#FASTLY fetch

  if ((beresp.status == 500 || beresp.status == 503) && req.restarts < 1 && (req.request == "GET" || req.request == "HEAD")) {
    restart;
  }
  
  if(req.restarts > 0 ) {
    set beresp.http.Fastly-Restarts = req.restarts;
  }

  if (beresp.http.Set-Cookie) {
    set req.http.Fastly-Cachetype = "SETCOOKIE";
    return (pass);
  }

  if (beresp.http.Cache-Control ~ "private") {
    set req.http.Fastly-Cachetype = "PRIVATE";
    return (pass);
  }

  if (beresp.status == 500 || beresp.status == 503) {
    set req.http.Fastly-Cachetype = "ERROR";
    set beresp.ttl = 1s;
    set beresp.grace = 5s;
    return (deliver);
  }  

  if (beresp.http.Expires || beresp.http.Surrogate-Control ~ "max-age" || beresp.http.Cache-Control ~"(s-maxage|max-age)") {
    # keep the ttl here
  } else {
    # apply the default ttl
    set beresp.ttl = 3600s;
  }

  return(deliver);
}

sub vcl_hit {
#FASTLY hit

  if (!obj.cacheable) {
    return(pass);
  }
  return(deliver);
}

sub vcl_miss {
#FASTLY miss
  return(fetch);
}

sub vcl_deliver {
#FASTLY deliver
  return(deliver);
}

sub vcl_error {
  if (obj.status == 666) {
    set obj.status = 405;
    synthetic {"No auth cookie or username detected"};
    set obj.http.Content-Type = "text/plain";
  }
#FASTLY error
}

sub vcl_pass {
#FASTLY pass
}