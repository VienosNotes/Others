(* 課題2.2 *)

(* 2.2.2で引算と割算を追加した型の定義は以下のようになる。 *)
type exp =
  | IntLit of int         (* リテラル *)
  | Plus of exp * exp     (* 足し算 *)
  | Times of exp * exp    (* かけ算 *)
  | Sub of exp * exp      (* 引き算 *)
  | Div of exp * exp      (* 割り算 *);;

(* 2.2.1 *)
IntLit 1;;
Plus(IntLit 1, IntLit 3);;
(* 実行結果は以下のとおり。
   #     - : exp = IntLit 1
   # - : exp = Plus (IntLit 1, IntLit 3)
   正しく解釈できている。
 *)

(* 2.2.3 式Eを受け取り、Plus(E + IntLit2)を返す関数。*)
let func (e:exp) =
  Plus(e, IntLit 2);;

let sample:exp =  Div(Plus(IntLit 1, Times(IntLit (-2), IntLit 5)), Sub(IntLit 4, IntLit (-3)));;

func sample;;
(* 実行結果は以下のとおり。
Plus
 (Div (Plus (IntLit 1, Times (IntLit (-2), IntLit 5)),
   Sub (IntLit 4, IntLit (-3))),
 IntLit 2)
 *)

(* 2.2.4 式の中に出現する整数リテラルを絶対値にする関数 
   再帰的に式を辿って行き、整数リテラルをabs関数で絶対値にする。
*)
let rec abs_exp (e:exp) :exp = 
  match e with
    | IntLit i -> IntLit (abs i)
    | Plus(a, b) -> Plus((abs_exp a), (abs_exp b))
    | Times(a, b) -> Times((abs_exp a), (abs_exp b))
    | Sub(a, b) -> Sub((abs_exp a), (abs_exp b))
    | Div(a, b) -> Div((abs_exp a), (abs_exp b));;

abs_exp sample;;
(* 実行結果は以下のとおり。
   Div (Plus (IntLit 1, Times (IntLit 2, IntLit 5)), Sub (IntLit 4, IntLit 3))
 *)
