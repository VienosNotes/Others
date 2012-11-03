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
 
let emptyenv () = [];;

let ext env x v = (x,v) :: env;;

let rec lookup x env =
   match env with
   | [] -> failwith ("unbound variable: " ^ x)
   | (y,v)::tl -> if x=y then v 
                  else lookup x tl;;


let env = emptyenv();;
let env = ext env "x" (IntVal 1);;
let env = ext env "y" (BoolVal true);;
let env = ext env "z" (IntVal 5);;

let y = lookup "y" env;;
let w = lookup "w" env;;
