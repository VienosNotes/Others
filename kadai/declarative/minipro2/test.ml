
let rec range n m =
  if m > n then (range n (pred m)) @ [m]
  else [n]
;;

range 0 10;; 
