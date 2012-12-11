let run src =
  Eval.eval (Main.parse(src)) (Eval.emptyenv())
;;


(* let instr = run "let rec fib n = if n > 1 then fib(n-1) + fib(n-2) else 1 in fib 50";; *)
let instr = run "if 1 then 1 else 0";;

Am.am_eval instr;;










