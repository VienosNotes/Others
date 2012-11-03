module type QUEUE =
sig
  type 'a t
  val empty: 'a t 
  val enq : 'a t -> 'a -> 'a t
  val null : 'a t -> bool
  val deq : 'a t -> 'a * 'a t
end;;

module Queue3:QUEUE =
struct
  type 'a t = 'a list * 'a list
  let empty = ([], [])
  let norm (l1, l2) =
    match l1 with
        [] -> (List.rev l2, []) 
      | _ -> (l1, l2)
  let enq (l1, l2) x = norm (l1, x::l2)
  let null q =
    match q with
        ([],[]) -> true
      | _  -> false
  let deq (l1,l2) =
    match l1 with
        x::l1' -> (x, norm (l1', l2))
      | _ -> raise (Failure "deq")
end
  
(* 6.1.1 *)
let enqlist q list =
  List.fold_left (fun queue x -> Queue3.enq queue x) q list
;;

(* 6.1.2 *)
let print_int_queue q =
  let tmp = ref q in
  try
    while true do
      let x,queue = Queue3.deq !tmp in
      tmp := queue;
      print_int x;
      print_string "\n"
    done
  with Failure "deq" -> ()
;;

let q = enqlist Queue3.empty [1;2;3];;
let x,q = Queue3.deq q;;
let x,q = Queue3.deq q;;
let x,q = Queue3.deq q;;

let q = enqlist Queue3.empty [1;2;3];;
print_int_queue q;;

