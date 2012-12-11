let run src =
  Eval.eval6 (Main.parse(src)) (Eval.emptyenv())
;;




run "let rec fib n = if n > 1 then fib(n-1) + fib(n-2) else 1 in fib 50";;


(* run "let rec sum x = if x = [] then 0 else (List.hd x) + sum(List.tl x) in sum (1::2::3::[])";; *)
(* run "1::2::[]";; *)
(* run "(1::(2::(3::[])))";; *)
(* run "true::false::[]";; *)
(* run "List.hd (1::2::3::[])";; *)
(* run "List.tl (1::2::3::[])";; *)

(* run "((3::2::1::[])::((true::false::[])::(1::2::3::[])::[]))";; *)
(* run "1::true::[]";; *)
(* run "((3::true::1::[])::((true::false::(1::[])::[])::(1::2::3::[])::[]))";; *)



