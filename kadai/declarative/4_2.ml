(* リストのリストを連結 *)
let flatten l =
  if l = [] then
    []
  else
    List.fold_right (fun x flat -> x @ flat) l [];;

flatten [[1; 2]; []; [3]];;

(* 要素がリストにあるか調べる *)
let exists f l =
  List.fold_left (fun flag x -> if not flag then f x else flag) false l;;

exists (fun x -> x > 1) [0; 3];;
