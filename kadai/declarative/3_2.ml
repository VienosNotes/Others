(* 木の定義 *)
type 'a tree =
  | Lf
  | Br of 'a * 'a tree * 'a tree;;

(* 木の深さを求める関数 *)
let rec depth (t:'a tree) =
  match t with
    | Lf -> 0
    | Br (v, t1, t2) -> 1 + max (depth t1) (depth t2);;

(*ラベルXの完全二分木を返す関数 *)
let rec comptree (n:int) x =
    if n = 0 then Lf else Br (x, (comptree (n - 1) x), (comptree (n - 1) x));;

let sample = Br(2, Br(4, Br(5, Lf, Lf), Lf), Br(1, Lf, Lf));;
depth sample;;
comptree 5 "a";;
