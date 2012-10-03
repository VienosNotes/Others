let table = Hashtbl.create 1024;;

let memo (n, m) =
  if List.mem_assoc n table then
    table [(n, m)];
  return m;;

let rec fib n =
  if List.mem_assoc n table then List.assoc n table
  else match n with
      1 -> 1
    | 2 -> 1
    | n -> memo(n-1, fib(n-1)) + memo(n-2, fib(n-2));;

fib(6);;
