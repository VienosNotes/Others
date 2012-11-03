(* 5.3.1 *)
let count_lines file =
  let inchan = open_in file in
  let lines = ref 0 in
  try
    while true do
      let _ = input_line inchan in
      lines := !lines + 1
    done;
    0
  with End_of_file -> close_in inchan;
    !lines;;

count_lines "test.txt";;

(* 
   val count_lines : string -> int = <fun>
#  - : int = 8
 *)
