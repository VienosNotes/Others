(* 集合の交わり *)
let rec inter l1 l2 =
  match l1 with
    | [] -> []
    | head::rest -> List.filter (fun x -> head = x) l2 @ inter rest l2
;;

inter [3; 1; 2] [2; 3];;

(* ある値と対にする *)
let pair v l =
  List.map (fun x -> (v, x)) l
;;

pair 1 ["A"; "B"; "C"];;

(* 直積 *)
let rec prod l1 l2 =
  match l1 with
    | [] -> []
    | head::rest -> pair head l2 @ prod rest l2
;;

prod [1; 2; 3] ["A"; "B"];;
