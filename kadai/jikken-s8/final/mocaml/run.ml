let run src =
  Eval.eval (Main.parse(src)) (Eval.emptyenv())
;;


let instr = run "4/2-1+1+3*true";;

(* Am.am_eval instr;; *)
