(* 課題 2.3.1 *)

(* 型の定義 *)
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
  | _ -> failwith "unknown expression";;

(* 以下の式に対してテストを行った *)
let easy:exp = Plus(Times(IntLit 2, IntLit 2), Plus(IntLit 3, IntLit (-4)));;
let sample:exp =  Div(Plus(IntLit 1, Times(IntLit (-2), IntLit 5)), Sub(IntLit 4, IntLit (-3)));;

eval1 easy;;
eval1 sample;;
(* 実行結果は以下のとおり。
   # val sample : exp =
     Div (Plus (IntLit 1, Times (IntLit (-2), IntLit 5)),
     Sub (IntLit 4, IntLit (-3)))
   #   - : int = 3
   # Exception: Failure "unknown expression".
   # 
   正しく解釈できており、また解釈できない場合においては例外が発生している。
*)


