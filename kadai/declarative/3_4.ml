(*有限分岐木の定義 *)
type 'a ftree = FBr of 'a * 'a ftree list

(* 深さを求める *)
let rec fdepth tree =
  let rec ts list =
  match list with
    | [] -> 0
    | head::rest -> max (fdepth head) (ts rest) in 
  match tree with
    | FBr (value, list) -> ts list + 1;;

fdepth (FBr (1, [FBr (2,[]); FBr (3, [FBr (4, [])])]));;

(* 先順で走査 *)
let rec fpreorder tree =
  let rec fpreorder_ts tree =
  match tree with
    | [] -> []
    | head::rest -> fpreorder head @ fpreorder_ts rest in
  match tree with
    | FBr (value, treelist) -> [value] @ fpreorder_ts treelist;;

fpreorder (FBr (1, [FBr (2, [FBr (3, []); FBr (4, [])]); FBr (5, [])]));;

