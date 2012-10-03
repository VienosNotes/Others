type 'a btree = 
    Lf
  | Br of 'a * 'a btree * 'a btree;;

(* 新しい要素を追加 *)
let rec add elt tree =
  match tree with
    | Br (value, left, right) ->
        if elt = value then
          Br (value, left, right)
        else if elt < value then
          Br (value, add elt left, right)
        else
          Br (value, left, add elt right)
    | Lf -> Br (elt, Lf, Lf);;

let tr = add 3 (add 1 (add 2 Lf));;

(* 最小の要素を返す *)
let rec min_elt tree =
  match tree with
    | Br (value, Lf, _) -> value
    | Br (value, left,_) -> min_elt left
    | Lf -> failwith "must not be reached";;

min_elt tr;;

(* 要素を削除 *)
let rec remove elt tree =
  match tree with
    | Br (v, Lf, Lf) ->
        if elt = v then
          Lf
        else
          tree
    | Br (v, left, Lf) ->
        if elt = v then
          left
        else
          Br (v, remove elt left, Lf)
    | Br (v, Lf, right) ->
        if elt = v then
          right
        else
          Br (v, Lf, remove elt right)
    | Br (v, left, right) ->
        if elt = v then
          let root = min_elt right in
          Br (root, left, remove root right)
        else if elt < v then
          Br (v, remove elt left, right)
        else
          Br (v, left, remove elt right)
    | Lf -> Lf;;

remove 3 tr;
