  if(req.url ~ "/api/test1") {
    set req.backend = origin1;
    set req.http.host = "origin1.jdade.me.uk";
  }