include "tier3";

sub my_func_2 {
  set req.http.tier3 = "accessed";
}