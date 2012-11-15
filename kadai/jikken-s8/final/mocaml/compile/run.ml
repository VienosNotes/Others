let run src =
  Eval.eval (Main.parse(src)) (Eval.emptyenv())
;;


let instr = run "let rec fact x = if x = 0 then 1 else x * fact (x-1) in fact 10";;

(* let instr = run "let rec fib x = if x > 1 then (fib (x-1)) + (fib (x-2)) else 1 in fib 25";; *)

Am.am_eval instr;;
