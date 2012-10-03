(* 課題 2.1 - 1 *)
let rec sum = function
  [] -> 0
  | n::rest -> n + sum rest;;

assert (sum [1;2;3] = 6);;
assert (sum [] = 0);;

(* 課題 2.1 - 2 *)
let sum2 l =
  let rec sum2_internal l i =
    match l with
        [] -> i
      | n::rest -> sum2_internal rest (i+n)
  in
  sum2_internal l 0;;

assert (sum2 [1;2;3] = 6);;
assert (sum2 [] = 0);;

(* 課題 2.1 - 3 *)
let average l =
  let rec list_avg_internal l count sum =
    match l with
      [] -> if count != 0 then float_of_int sum /. float_of_int count else 0.0;
      | n::rest -> list_avg_internal rest (count + 1) (sum + n)
  in
  list_avg_internal l 0 0;;

assert (average [1;2;3] = 2.0);;
assert (average [1;2;3;4] = 2.5);;
assert (average [] = 0.0);; 
assert (average [1;-1] = 0.0);;
