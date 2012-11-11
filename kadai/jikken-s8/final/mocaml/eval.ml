(* eval2b : exp -> value *)

open Syntax;;
open Am;;

let emptyenv () = [];;

let ext env x v = (x,v) :: env;;

let rec lookup x env =
   match env with
   | [] -> failwith ("unbound variable: " ^ x)
   | (y,v)::tl -> if x=y then v 
                  else lookup x tl;;
  let rec position (x : string) (venv : string list) : int =
    match venv with
      | [] -> failwith "no matching variable in environment"
      | y::venv2 -> if x=y then 0 else (position x venv2) + 1;;

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

let rec eval e env =           (* env を引数に追加 *)
  let binop f e1 e2 env =       (* binop の中でも eval を呼ぶので env を追加 *)
    match (eval e1 env , eval e2 env ) with
    | (IntVal(n1),IntVal(n2)) -> 
    | _ -> failwith "integer value expected"
  in
  match e with
  (* | Var(x)       -> lookup x env *)
  | IntLit(n)    -> [I_Ldi n]
  | BoolLit(b) -> [I_Ldb b]
  | Plus(e1,e2)  -> binop I_Add e1 e2 env
  | Plus(e1,e2)  -> (eval e1 env) @ [I_Push] @ (eval e2 env) @ [I_Add]    (* env を追加 *)
  | Times(e1,e2) ->  (eval e1 env)@ [I_Push] @ (eval e2 env) @ [I_Mult]   (* env を追加 *)
  | Minus(e1, e2) -> (eval e1 env)@ [I_Push] @ (eval e2 env) @ [I_Sub]   (* env を追加 *)
  | Div(e1, e2) -> (eval e1 env)@ [I_Push] @ (eval e2 env) @ [I_Div]   (* env を追加 *)
 (*  | Eq(e1,e2) -> *)
 (*      begin *)
 (*        match (eval e1 env , eval e2 env ) with *)
 (*          | (IntVal(n1),IntVal(n2)) -> BoolVal(n1=n2) *)
 (*          | (BoolVal(b1),BoolVal(b2)) -> BoolVal(b1=b2) *)
 (*          | _ -> failwith "wrong value" *)
 (*      end *)
 (*  | If(e1,e2,e3) -> *)
 (*      begin *)
 (*        match (eval e1 env ) with          (\* env を追加 *\) *)
 (*          | BoolVal(true)  -> eval e2 env   (\* env を追加 *\) *)
 (*          | BoolVal(false) -> eval e3 env   (\* env を追加 *\) *)
 (*          | _ -> failwith "wrong value" *)
 (*      end *)
 (*  | Let(x,e1,e2) ->  *)
 (*      let env1 = ext env x (eval e1 env ) *)
 (*      in eval e2 env1  *)
 (* | LetRec(f,x,e1,e2) -> *)
 (*      let env1 = ext env f (RecFunVal (f, x, e1, env)) *)
 (*      in eval e2 env1 *)
 (*  | Noteq(e1, e2) -> *)
 (*      begin *)
 (*        match (eval e1 env , eval e2 env ) with *)
 (*          | (IntVal(n1),IntVal(n2)) -> BoolVal(n1!=n2) *)
 (*          | (BoolVal(b1),BoolVal(b2)) -> BoolVal(b1!=b2) *)
 (*          | _ -> failwith "wrong value" *)
 (*      end *)
 (*  | Fun(x,e1) -> FunVal(x, e1, env) *)
 (*  | App(e1,e2) -> *)
 (*      let funpart = (eval e1 env) in *)
 (*      let arg = (eval e2 env) in *)
 (*        begin *)
 (*         match funpart with *)
 (*         | FunVal(x,body,env1) -> *)
 (*            let env2 = (ext env1 x arg) in *)
 (*            eval body env2 *)
 (*         | RecFunVal(f,x,body,env1) -> *)
 (*            let env2 = (ext (ext env1 x arg) f funpart) in *)
 (*            eval body env2 *)
 (*         | _ -> failwith "wrong value in App" *)
 (*        end *)
 (*  | Greater(e1, e2) ->  *)
 (*      begin *)
 (*        match (eval e1 env , eval e2 env ) with *)
 (*          | (IntVal(n1), IntVal(n2)) -> BoolVal(n1 > n2) *)
 (*          | _ -> failwith "wrong value" *)
 (*      end *)
  | _ -> failwith "unknown expression";;
