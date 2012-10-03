(* 課題2.3.2 *)

type exp =
  | IntLit of int         (* リテラル *)
  | Plus of exp * exp     (* 足し算 *)
  | Times of exp * exp    (* かけ算 *)
  | Sub of exp * exp      (* 引き算 *)
  | Div of exp * exp      (* 割り算 *);;

let rec eval1 e =
  match e with
  | IntLit(n)    -> n
  | Plus(e1,e2)  -> (eval1 e1) + (eval1 e2)
  | Times(e1,e2) -> (eval1 e1) * (eval1 e2)
  | Sub(e1, e2)  -> (eval1 e1) - (eval1 e2)
  | Div(e1, IntLit 0) -> failwith "divide by zero"
  | Div(e1, e2) -> (eval1 e1) / (eval1 e2)
  | _ -> failwith "unknown expression";;

let easy:exp = Plus(Times(IntLit 2, IntLit 2), Plus(IntLit 3, IntLit (-4)));;
let sample:exp =  Div(Plus(IntLit 1, Times(IntLit (-2), IntLit 5)), Sub(IntLit 4, IntLit (-3)));;
let zero:exp = Div(IntLit 1, IntLit 0);;

eval1 easy;;
eval1 sample;;
eval1 zero;;

(* 実行結果は以下のとおり。
   #   - : int = 3
   # - : int = -1
   # Exception: Failure "divide by zero".
*)
