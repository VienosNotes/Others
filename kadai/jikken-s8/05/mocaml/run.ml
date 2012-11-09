let run src =
  Eval.eval4 (Main.parse(src)) (Eval.emptyenv())
;;

run "
let x = 1 in
  let f = fun y -> x + y in
    let x = 2 in
      f (x + 3)";

run "let fact = fun x -> (if (x > 0) then x * fact(x-1) else 1) in fact(10)";;

