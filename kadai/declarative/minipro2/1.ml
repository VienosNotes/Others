let rec range n m =
  if m > n then (range n (pred m)) @ [m]
  else [n]
;;

let pi = 3.141592;;

let draw_regular_ngon x y r c n =
    List.fold_left (fun acc i -> 
        let v_x = r *. (cos (2. *. pi *. (float acc) /. (float n))) in
        let v_y = r *. (sin (2. *. pi *. (float acc) /. (float n))) in
        let start_x = x +. v_x in
        let start_y = y +. v_y in

        let v_x = r *. (cos (2. *. pi *. (float i) /. (float n))) in
        let v_y = r *. (sin (2. *. pi *. (float i) /. (float n))) in
        let dest_x = x +. v_x in
        let dest_y = y +. v_y in
        Graphics.set_color c;
        Graphics.moveto (int_of_float start_x) (int_of_float start_y);
        Graphics.lineto (int_of_float dest_x) (int_of_float dest_y);
        i
    ) 0 (range 1 n)
;;

let main x y r c n =
  let rec loop () =
    let status = Graphics.wait_next_event
      [Graphics.Key_pressed] in
    if status.Graphics.keypressed then ()
    else loop () in
  Graphics.open_graph " 100x100";
  draw_regular_ngon x y r c n;
  loop ();
  Graphics.close_graph ()
;;
