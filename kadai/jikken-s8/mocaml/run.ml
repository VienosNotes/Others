let run src =
  Eval.eval3 (Main.parse(src)) (Eval.emptyenv())
;;


run "1+2*3";;
