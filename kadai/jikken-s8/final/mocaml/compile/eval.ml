open Syntax;;
open Am;;

let emptyenv () = [];;

let rec position (x : string) (venv : string list) : int =
  match venv with
    | [] -> failwith "no matching variable in environment"
    | y::venv2 -> if x=y then 0 else (position x venv2) + 1;;

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
  | Noteq(e1,e2) -> binop I_Noteq e1 e2 env
  | If(e1,e2,e3) -> (eval e1 env) @ [I_Test ((eval e2 env), (eval e3 env))]
  | Let(x,e1,e2) -> 
      let env1 = x::env in
      [I_Pushenv] @ (eval e1 env) @ [I_Extend] @ (eval e2 env1) @ [I_Popenv]      
 | LetRec(f,x,e1,e2) -> 
     let env1 = f::env in
      [I_Pushenv] @ [I_Mkclos (eval e1 (x::env1))] @ [I_Extend] @ (eval e2 env1) @ [I_Popenv]
  | Fun(x,e1) -> [I_Mkclos (eval e1 (x::("_"::env)))]
  | App(e1,e2) -> [I_Pushenv] @ (eval e2 env) @ [I_Push] @ (eval e1 env) @ [I_Apply; I_Popenv] 
  | Greater(e1, e2) -> binop I_Greater e1 e2 env
  | _ -> failwith "unknown expression";;


