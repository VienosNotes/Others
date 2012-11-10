let run src =
  Eval.eval6 (Main.parse(src)) (Eval.emptyenv())
;;



run "let rec f x = x in 0";;
run "let rec f x = x in f 0";;
run "let rec f x = if x = 0 then 1 else 2 + f (x + (-1)) in f 1";;
run "let rec f x = if x = 0 then 1 else x * f (x + (-1)) in f 3";;
run "let rec f x = if x = 0 then 1 else x * f (x + (-1)) in f 5";;

run "let rec fib x = if x = 0 then 0 else x + fib(x - 1) in fib 100";;
