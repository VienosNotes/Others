(* 課題 2.3 - 1 *)
let rec drop l i =
  if i > 0 then
    match l with
        [] -> []
      | n::rest -> drop rest (i-1)
  else l;;

assert(drop [1;2;3;4;5;6;7;8;9;10] 4 = [5;6;7;8;9;10]);;
assert(drop [1;2;3] 10 = []);;
assert(drop [1] 0 = [1]);;
assert(drop [] 5 = []);;
