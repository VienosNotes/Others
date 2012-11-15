let run src =
  Eval.eval3 (Main.parse(src)) (Eval.emptyenv())
;;


run "1+2*3";;

run "true <> false";;
run "(1+1) <> 2";;
run "let x = 1 in let y = 2 in x <> y";;
