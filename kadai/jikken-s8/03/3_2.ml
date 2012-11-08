(* eval2b : exp -> value *)
let debug = false;

type exp =
  | IntLit of int
  | Plus of exp * exp 
  | Times of exp * exp
  | BoolLit of bool        (* 追加分; 真理値リテラル, つまり trueや false  *)
  | If of exp * exp * exp  (* 追加分; if-then-else式 *)
  | Eq of exp * exp        (* 追加分; e1 = e2 *)
  | Greater of exp * exp 
  | Var of string        
  | Let of string * exp * exp ;;

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

let string_of_env env =
  let string_of_val (e:value) : string =
    match e with
      | IntVal n -> string_of_int n
      | BoolVal true ->  "true"
      | BoolVal false ->  "false"
  in
  let rec internal (env:(string * value) list) =
    match env with
      | [] -> ""
      | (name, v)::rest -> name ^ " = " ^ (string_of_val v) ^ ";" ^ (internal rest)
  in
  "[" ^ (internal env) ^ "]";;

(* eval3 : exp -> (string * value) list -> value *)
(* let と変数、環境の導入 *)
let print_env (env: (string * value) list) =
  print_string( string_of_env env);;

let rec eval3 ?(mode=0) e env =           (* env を引数に追加 *)
  if mode != 0 then print_env env;

  let binop f e1 e2 env =       (* binop の中でも eval3 を呼ぶので env を追加 *)
    match (eval3 e1 env ~mode, eval3 e2 env ~mode) with
    | (IntVal(n1),IntVal(n2)) -> IntVal(f n1 n2)
    | _ -> failwith "integer value expected"
  in 
  match e with
  | Var(x)       -> lookup x env
  | IntLit(n)    -> IntVal(n)
  | BoolLit(b) -> BoolVal(b)
  | Plus(e1,e2)  -> binop (+) e1 e2 env     (* env を追加 *)
  | Times(e1,e2) -> binop ( * ) e1 e2 env   (* env を追加 *)
  | Eq(e1,e2) ->
      begin
	match (eval3 e1 env ~mode, eval3 e2 env ~mode) with
	  | (IntVal(n1),IntVal(n2)) -> BoolVal(n1=n2)
	  | (BoolVal(b1),BoolVal(b2)) -> BoolVal(b1=b2)
	  | _ -> failwith "wrong value"
      end
  | If(e1,e2,e3) ->
      begin
        match (eval3 e1 env ~mode) with          (* env を追加 *)
          | BoolVal(true)  -> eval3 e2 env   (* env を追加 *)
          | BoolVal(false) -> eval3 e3 env   (* env を追加 *)
          | _ -> failwith "wrong value"
      end
  | Let(x,e1,e2) -> 
      let env1 = ext env x (eval3 e1 env ~mode)
      in eval3 e2 env1 ~mode
  | _ -> failwith "unknown expression";;


(* 3.2.1 *)
eval3 (Let ("x", IntLit 1, (Plus (IntLit 2, Var "x")))) [];;
eval3 (Let ("x", IntLit 1, Let("y", IntLit 3, (Plus (Var "y", Var "x"))))) [];;
eval3 (Let ("x", BoolLit true, If(Eq(Var "x", BoolLit true), IntLit 1, IntLit 2))) [];;
(* 3.2.2 *)
eval3 (Let ("x", IntLit 1, (Let ("x", IntLit 2, Var "x")))) [];;
(* 3.2.3 *)
eval3 ~mode:1  (Let ("x", IntLit 1, (Let ("y", Plus(Var "x", IntLit 1), Plus(Var "x", Var "y"))))) [];;
(* 3.2.4 *)
eval3 (Let ("x", IntLit 1, Plus(Let("x", IntLit 2, Plus(Var "x", IntLit 1)), Times(Var "x", IntLit 2)))) [];;

print_env [("x", IntVal 1); ("y", IntVal 2); ("z", BoolVal true)]
