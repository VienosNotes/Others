let run src =
  Eval.eval (Main.parse(src)) (Eval.emptyenv())
;;


let instr = run "let rec foo x = if x = 0 then 1 else x * foo (x + (-1)) in foo 5";;

Am.am_eval instr;;
