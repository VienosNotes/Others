let rec fib n = 
  match n with
      1 -> 1
    | 2 -> 1
    | n -> fib(n - 2) + fib(n - 1);;

fib 90000;;

