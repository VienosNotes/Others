(* 5.2.1 *)

exception Zero;;

let preprod l =
  if l = [] then
    0
  else
    let rec preprod_loop l prd =
      match l with
          [] -> prd
        |   head::rest ->
            if head = 0 then
              raise Zero
            else
              preprod_loop rest (prd * head)
    in
    preprod_loop l 1;;

preprod [];;
preprod [2;3;4];;
preprod [2;0;4];;

(* 5.2.2 *)
let prod l =
  try
    preprod l
  with
      Zero -> 0;;

prod [];;
prod [2;3;4];;
prod [2;0;4];;


(* 
# val preprod : int list -> int = <fun>
#  - : int = 0
# - : int = 24
# Exception: Zero.
# val prod : int list -> int = <fun>
# - : int = 0
# - : int = 24
# - : int = 0
#
 *)
