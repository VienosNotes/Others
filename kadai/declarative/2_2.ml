(* 課題 2.2 - 1 *)
let summation f m =
let rec summation_internal f m sum =
  if m >= 0 then
    summation_internal f (m-1) (sum + f m)
  else
    sum
  in
  summation_internal f m 0;;

assert (summation (fun x -> x) 3 = 6);;
assert (summation (fun x -> x + 1) 5 = 21);;

(* 課題 2.2 - 2 *)
let summation2 (f:int * int -> int) (arg:int * int) =
  let rec summation2_internal (f:int * int -> int) arg sum =
    let (m, n) = arg in
    if m >= 0 then
      summation2_internal f ((m-1), n) (sum+(summation (fun n -> f(m,n)) n))
    else
      sum 
  in
  summation2_internal f arg 0;;

assert (summation2 (fun (x,y) -> x+y) (2,2) = 18);;
assert (summation2 (fun (x,y) -> x*y) (3,3) = 36);;
