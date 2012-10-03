type 'a tree =
  | Lf
  | Br of 'a * 'a tree * 'a tree;;

let sample = Br(2, Br(4, Br(5, Lf, Lf), Lf), Br(1, Lf, Lf));;

(* 中順でリスト化 *)
let rec inorder (t:'a tree) =
  match t with
    | Lf -> []
    | Br(label, l, r) -> (inorder l) @ [label] @ (inorder r);;

(* 後順でリスト化 *)
let rec postorder (t:'a tree) =
  match t with
    | Lf -> []
    | Br(label, l, r) -> (inorder l) @ (inorder r) @ [label];;

inorder sample;;
postorder sample;;
