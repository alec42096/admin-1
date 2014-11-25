include "tier2";

sub my_func {
  set req.http.tier2 = "accessed";
}