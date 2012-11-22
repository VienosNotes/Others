type pos = {mutable x : float; mutable y : float}

let rec range n m =
  if m > n then (range n (pred m)) @ [m]
  else [n]
;;

let pi = 3.14;;

let draw_regular_ngon x y r c n =
    let start = {x = 0.; y = 0.;} in
    let dest = {x = 0.; y = 0.;} in
    let vect = {x = 0.; y = 0.;} in

    List.fold_left (fun acc i -> 
        vect.x <- r *. (cos (2. *. pi *. (float acc) /. (float n)));
        vect.y <- r *. (sin (2. *. pi *. (float acc) /. (float n)));
        start.x <- x +. vect.x;
        start.y <- y +. vect.y;

        vect.x <- r *. (cos (2. *. pi *. (float i) /. (float n)));
        vect.y <- r *. (sin (2. *. pi *. (float i) /. (float n)));
        dest.x <- x +. vect.x;
        dest.y <- y +. vect.y;
        Graphics.set_color c;
        Graphics.moveto (int_of_float start.x) (int_of_float start.y);
        Graphics.lineto (int_of_float dest.x) (int_of_float dest.y);
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
