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
    (eval e2 env) @ [I_Push] @ (eval e1 env) @ [f]
  in
  match e with
  | Var(x)       -> [I_Search (position x env)]
  | IntLit(n)    -> [I_Ldi n]
  | BoolLit(b) -> [I_Ldb b]
  | Plus(e1,e2)  -> binop I_Add e1 e2 env
  | Minus(e1,e2) -> binop I_Sub e1 e2 env
  | Times(e1,e2) -> binop I_Mult e1 e2 env
  | Div(e1,e2) -> binop I_Div e1 e2 env
  | Eq(e1,e2) -> binop I_Eq e1 e2 env
 (*      begin *)
 (*        match (eval e1 env , eval e2 env ) with *)
 (*          | (IntVal(n1),IntVal(n2)) -> BoolVal(n1=n2) *)
 (*          | (BoolVal(b1),BoolVal(b2)) -> BoolVal(b1=b2) *)
 (*          | _ -> failwith "wrong value" *)
 (*      end *)
  | If(e1,e2,e3) -> (eval e1 env) @ [I_Test ((eval e2 env), (eval e3 env))]
 (*      begin *)
 (*        match (eval e1 env ) with          (\* env を追加 *\) *)
 (*          | BoolVal(true)  -> eval e2 env   (\* env を追加 *\) *)
 (*          | BoolVal(false) -> eval e3 env   (\* env を追加 *\) *)
 (*          | _ -> failwith "wrong value" *)
 (*      end *)
  | Let(x,e1,e2) -> 
      let env1 = x::env in
      [I_Pushenv] @ (eval e1 env) @ [I_Extend] @ (eval e2 env1) @ [I_Popenv]
      
 | LetRec(f,x,e1,e2) -> 
     let env1 = f::env in
      [I_Pushenv] @ [I_Mkclos (eval e1 (x::env1))] @ [I_Extend] @ (eval e2 env1) @ [I_Popenv]
 (*      let env1 = ext env f (RecFunVal (f, x, e1, env)) *)
 (*      in eval e2 env1 *)
 (*  | Noteq(e1, e2) -> *)
 (*      begin *)
 (*        match (eval e1 env , eval e2 env ) with *)
 (*          | (IntVal(n1),IntVal(n2)) -> BoolVal(n1!=n2) *)
 (*          | (BoolVal(b1),BoolVal(b2)) -> BoolVal(b1!=b2) *)
 (*          | _ -> failwith "wrong value" *)
 (*      end *)
  | Fun(x,e1) -> [I_Mkclos (eval e1 (x::("_"::env)))]

  | App(e1,e2) -> [I_Pushenv] @ (eval e2 env) @ [I_Push] @ (eval e1 env) @ [I_Apply; I_Popenv] 
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
  | Greater(e1, e2) -> binop I_Noteq e1 e2 env
 (*      begin *)
 (*        match (eval e1 env , eval e2 env ) with *)
 (*          | (IntVal(n1), IntVal(n2)) -> BoolVal(n1 > n2) *)
 (*          | _ -> failwith "wrong value" *)
 (*      end *)
  | _ -> failwith "unknown expression";;


