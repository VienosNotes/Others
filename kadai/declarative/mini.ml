let base_bits = 31
let base_mask = (1 lsl base_bits) - 1

let suint_inc m =
  let x = m + 1 in
  let r = x land base_mask in
  (r, x <> r);;

let suint_add_carry m n c =
  let x = n + m in
  let x = if c then x + 1 else x in
  let r = x land base_mask in
  (r, x <> r);;

let high_mask = base_mask lsl base_bits

let suint_mult m n =
let x = n * m in
let l = x land base_mask in
let h = (x land high_mask) lsr base_bits in
(h, l)

(* 1 *)
let buint_add (bi1 : int list) (bi2 : int list) : int list =
  let myhd l =
    match l with
      | [] -> 0
      | hd::tl -> hd in
  let mytl l =
    match l with
      | [] -> []
      | hd::tl -> tl in
  let rec buint_add_carry bc1 bc2 cr =
    if bc1 = [] && bc2 = [] then
      if cr then [1] else []        
    else let (sum, carry) = suint_add_carry (myhd bc1) (myhd bc2) cr in
    sum::(buint_add_carry (mytl bc1) (mytl bc2) carry)
  in
  buint_add_carry bi1 bi2 false;;

(* 2 *)
let buint_fib2 (n:int) :int list * int list =
  let rec fib2_internal f1 f2 ni =
    if n = ni then (f1, f2)
    else
      fib2_internal f2 (buint_add f1 f2) (ni+1)
  in
  fib2_internal [1] [1] 1;;

(* 3 *)
let buint_suint_mult l n =
  let rec mult_internal li ni ui ci =
    match li with
      | hd::tl -> let (upper, current) = suint_mult hd ni in
                  let (sum, carry) = suint_add_carry current ui ci in
                  [sum] @ mult_internal tl ni upper carry
      | _ -> let (s, c) = suint_add_carry 0 ui ci in 
             if s = 0 then [] else [s]
  in
  mult_internal l n 0 false;;

(* 4 *)
let buint_fact n =
  let rec fact_internal now ans =
    if now = 0 then
      ans
    else
      fact_internal (now-1) (buint_suint_mult ans now)
  in
  fact_internal n [1];;

(* 5 *)
let buint_mult target multiplier =
  let rec mult_internal target multiplier ans =
    match multiplier with
      | hd::tl -> let ans = if ans = [] then [] else [0] @ ans in
                  mult_internal target tl (buint_add ans (buint_suint_mult target hd))
      | _ -> ans
  in
  mult_internal target (List.rev multiplier) [0];;


(* run 1 - test input
% perl6 dec_to_n.pl '("1" x 10).Int ** 2' "2**31"                          
1234567900987654321 -> 2**31 based
[91750577; 574890478] # arg1

% perl6 dec_to_n.pl '("2" x 10).Int ** 2' "2**31"                          
4938271603950617284 -> 2**31 based
[367002308; 152078264; 1] # arg2

% perl6 dec_to_n.pl '(("1" x 10).Int ** 2) + (("2" x 10).Int ** 2)' "2**31"
6172839504938271605 -> 2**31 based
[458752885; 726968742; 1] # expected answer
 *)
buint_add [91750577; 574890478] [367002308; 152078264; 1];;

(* run 2 - test input 
% perl6 dec_to_n.pl `perl6 fib.pl 100` 
354224848179261915075 -> 2**31 based
[1167376323; 1740041551; 76] # expected answer
 % perl6 dec_to_n.pl `perl6 fib.pl 101`                                   
573147844013817084101 -> 2**31 based
[277887173; 604790509; 124] # expected answer
 *)
buint_fib2 100;;

(* run 3 - test input
 % perl6 dec_to_n.pl "`perl6 fib.pl 100` * (1 x 10)"     
393583164604266033618970898325 -> 2**31 based
[444755861; 1144662764; 1592882151; 39] # expected answer
 *)
let (num, _) = buint_fib2 100 in
buint_suint_mult num 1111111111;;

(* run 4 - test input
% perl6 dec_to_n.pl '(sub fact($_) { $_ ?? $_ * fact($_ -1) !! 1}).(25)'
15511210043330985984000000 -> 2**31 based
[2076180480; 1128227104; 3363457] # expected answer
 *)
buint_fact 25;;

(* run 5 - test input
% perl6 dec_to_n.pl '(("1" x 10).Int ** 2) * (("2" x 10).Int ** 2)' "2**31"
6096631608596250571925011431159884164 -> 2**31 based
[1069672836; 1984622252; 393424931; 615602474] # expecter answer
 *)
buint_mult  [91750577; 574890478] [367002308; 152078264; 1];;

                  
    
    
