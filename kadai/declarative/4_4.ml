type 'a ftree = FBr of 'a * 'a ftree list;;

(* 木の深さを返す *)
let rec fdepth tree =
  let FBr (_, trlist) = tree in
  (List.fold_left (fun d tree -> max d (fdepth tree)) 0 trlist) + 1;;

fdepth (FBr (1, [FBr (2,[]); FBr (3, [FBr (4, [])])]));;

(* 先順で走査 *)
let rec fpreorder tree =
  let FBr (v, trlist) = tree in
  v :: List.fold_left (fun l tree -> l @ (fpreorder tree)) [] trlist;;

fpreorder (FBr (1, [FBr (2, [FBr (3, []); FBr (4, [])]); FBr (5, [])]));;
