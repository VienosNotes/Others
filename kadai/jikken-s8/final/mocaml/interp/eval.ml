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

let rec eval6 e env =           (* env を引数に追加 *)
  let binop f e1 e2 env =       (* binop の中でも eval6 を呼ぶので env を追加 *)
    match (eval6 e1 env , eval6 e2 env ) with
    | (IntVal(n1),IntVal(n2)) -> IntVal(f n1 n2)
    | _ -> failwith "integer value expected"
  in 
  match e with
  | Var(x)       -> lookup x env
  | IntLit(n)    -> IntVal(n)
  | BoolLit(b) -> BoolVal(b)
  | Plus(e1,e2)  -> binop (+) e1 e2 env     (* env を追加 *)
  | Times(e1,e2) -> binop ( * ) e1 e2 env   (* env を追加 *)
  | Minus(e1, e2) -> binop (-) e1 e2 env
  | Eq(e1,e2) ->
      begin
	match (eval6 e1 env , eval6 e2 env ) with
	  | (IntVal(n1),IntVal(n2)) -> BoolVal(n1=n2)
	  | (BoolVal(b1),BoolVal(b2)) -> BoolVal(b1=b2)
	  | _ -> failwith "wrong value"
      end
  | If(e1,e2,e3) ->
      begin
        match (eval6 e1 env ) with          (* env を追加 *)
          | BoolVal(true)  -> eval6 e2 env   (* env を追加 *)
          | BoolVal(false) -> eval6 e3 env   (* env を追加 *)
          | _ -> failwith "wrong value"
      end
  | Let(x,e1,e2) -> 
      let env1 = ext env x (eval6 e1 env )
      in eval6 e2 env1 
 | LetRec(f,x,e1,e2) ->
      let env1 = ext env f (RecFunVal (f, x, e1, env))
      in eval6 e2 env1
  | Noteq(e1, e2) ->
      begin
	match (eval6 e1 env , eval6 e2 env ) with
	  | (IntVal(n1),IntVal(n2)) -> BoolVal(n1!=n2)
	  | (BoolVal(b1),BoolVal(b2)) -> BoolVal(b1!=b2)
	  | _ -> failwith "wrong value"
      end
  | Fun(x,e1) -> FunVal(x, e1, env)
  | App(e1,e2) ->
      let funpart = (eval6 e1 env) in
      let arg = (eval6 e2 env) in
        begin
         match funpart with
         | FunVal(x,body,env1) ->
            let env2 = (ext env1 x arg) in
            eval6 body env2
         | RecFunVal(f,x,body,env1) ->
            let env2 = (ext (ext env1 x arg) f funpart) in
            eval6 body env2
         | _ -> failwith "wrong value in App"
        end
  | Greater(e1, e2) -> 
      begin
        match (eval6 e1 env , eval6 e2 env ) with
          | (IntVal(n1), IntVal(n2)) -> BoolVal(n1 > n2)
          | _ -> failwith "wrong value"
      end
  | Cons(e1,e2) ->
     begin
      match (eval6 e1 env, eval6 e2 env) with
        | (v1, ListVal([])) -> ListVal([v1])
        | (IntVal(v1),ListVal(IntVal(v2)::v3)) -> ListVal(IntVal(v1)::(IntVal(v2)::v3))
        | (BoolVal(v1),ListVal(BoolVal(v2)::v3)) -> ListVal(BoolVal(v1)::(BoolVal(v2)::v3))
        | (ListVal(v1),ListVal(ListVal(v2)::v3)) -> ListVal(ListVal(v1)::(ListVal(v2)::v3))
        | _ -> failwith "mismatch type of elements";;
     end
  | Head e1 ->
      begin
        match (eval6 e1 env) with
          |  ListVal(v1::_) -> v1
          | _ -> failwith "argument is not a list."
      end     
  | Tail e1 ->
      begin
        match (eval6 e1 env) with
          | (ListVal (_::v1)) -> ListVal v1
          | _ -> failwith "argument is not a list."
      end
  | Empty -> ListVal([])
  | _ -> failwith "unknown expression";;
