(* let prime n = *)
(*   let rec sift (now:int) (count:int) (l:int list) (rest:int list) :int list = *)
(*     if count = 1 then rest else *)
(*       match l with *)
(*           n::[] -> sift (now+1) (count-1) (l@[now]) (l@[now]) *)
(*         | n::tail -> if (now mod n = 0) then sift (now+1) count l l else sift now count l tail *)
(*         | [] -> [] *)
(*   in *)
(*   sift 1 n [1] [1];; *)

(* prime 5;; *)

let prime (n:int) =

  let rec sift count (now:int) plist rest =
    print_int now;
    if count = 0 then List.hd(List.rev plist)
    else match rest with
        [] -> sift (count-1) (now+1) (plist@[now]) (plist@[now])
      | n::tail -> if now mod n = 0 then sift count (now+1) plist plist else sift count now plist rest
  in
  sift n 1 [2] [2];;
  
prime 5;;
