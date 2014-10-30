  if(req.url ~ "/api/test2") {
    set req.backend = origin2;
    set req.http.host = "origin2.jdade.me.uk";
  }