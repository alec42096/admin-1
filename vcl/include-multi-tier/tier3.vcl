include "tier4"

sub my_func_3 {
  set req.http.tier4 = "accessed";
}