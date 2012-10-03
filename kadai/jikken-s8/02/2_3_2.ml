


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
  | _ -> failwith "unknown expression"
  | Times(e1,e2) -> (eval1 e1) * (eval1 e2);;

let test:exp = Times(IntLit 1, IntLit 1);;
eval1 test;;

(* 実行結果
   # Exception: Failure "unknown expression".
 *)
