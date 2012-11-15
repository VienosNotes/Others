let run src =
  Eval.eval6 (Main.parse(src)) (Eval.emptyenv())
;;

run "let rec fact x = if x = 0 then 1 else x * fact (x-1) in fact 10";;

