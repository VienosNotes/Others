(* eval2b : exp -> value *)
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
binop (+) (IntLit 10) (IntLit 20);;
 
