(* eval2b : exp -> value *)

open Syntax;;

let emptyenv () = [];;

let ext env x v = (x,v) :: env;;

let rec lookup x env =
   match env with
   | [] -> failwith ("unbound variable: " ^ x)
   | (y,v)::tl -> if x=y then v 
                  else lookup x tl;;

let string_of_env env =
  let string_of_val e =
    match e with
      | IntVal n -> string_of_int n
      | BoolVal true ->  "true"
      | BoolVal false ->  "false"
  in
  let rec internal env = 
    match env with
      | [] -> ""
      | (name, v)::rest -> name ^ " = " ^ (string_of_val v) ^ ";" ^ (internal rest)
  in
  "[" ^ (internal env) ^ "]";;

(* eval3 : exp -> (string * value) list -> value *)
(* let と変数、環境の導入 *)
let print_env env =
  print_string(string_of_env env);;

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
