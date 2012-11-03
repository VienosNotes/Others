(* 5.1.1 *)
let array_sum2 a1 a2 =
  let len = min (Array.length a1) (Array.length a2) in
  Array.init len (fun idx -> a1.(idx) + a2.(idx));;

array_sum2 [|1; 2; 3|] [|4; 5|];;

(* 5.1.2 *)
let inner_prod a1 a2 =
  let len = Array.length a1 in
  let res = ref 0 in
  for i = 0 to len - 1 do
    res := !res + a1.(i) * a2.(i)
    done;
  !res;;

inner_prod [| 1; 2; 3 |] [| 2; 3; 4 |];;

(* 5.1.3 *)
let array_map f a =
  let len = Array.length a in
  Array.init len (fun idx -> f a.(idx))
;;

array_map (fun i -> i * i) [| 1; 2; 3 |];;

(* 
    val array_sum2 : int array -> int array -> int array = <fun>
#   - : int array = [|5; 7|]
#                 val inner_prod : int array -> int array -> int = <fun>
#   - : int = 20
#           val array_map : ('a -> 'b) -> 'a array -> 'b array = <fun>
#   - : int array = [|1; 4; 9|]
# 
*)
