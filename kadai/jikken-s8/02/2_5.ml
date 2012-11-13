(* eval2b : exp -> value *)

type exp =
  | IntLit of int
  | Plus of exp * exp 
  | Times of exp * exp
  | BoolLit of bool        (* 追加分; 真理値リテラル, つまり trueや false  *)
  | If of exp * exp * exp  (* 追加分; if-then-else式 *)
  | Eq of exp * exp        (* 追加分; e1 = e2 *)
  | Greater of exp * exp ;;

(* 値の型 *)
type value =
  | IntVal  of int          (* 整数の値 *)
  | BoolVal of bool         (* 真理値の値 *);;

let rec eval2b e =
  let binop f e1 e2 =
    match (eval2b e1, eval2b e2) with
      | (IntVal(n1),IntVal(n2)) -> IntVal(f n1 n2)
      | _ -> failwith "integer values expected"
  in 
  match e with
    | IntLit(n)    -> IntVal(n)
    | Plus(e1,e2)  -> binop (+) e1 e2
    | Times(e1,e2) -> binop ( * ) e1 e2

    | _ -> failwith "unknown expression";;

eval2b (Plus ((IntLit 10), (IntLit 20)));;

let binop f e1 e2 =
  match (eval2b e1, eval2b e2) with
    | (IntVal(n1),IntVal(n2)) -> IntVal(f n1 n2)
    | _ -> failwith "integer values expected";;
        
binop (+) (IntLit 10) (IntLit 20);;
 
