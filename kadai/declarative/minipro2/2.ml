open Graphics;;

type figure =
Rectangle of float * float (* 幅 * 高さ *)
  | Circle of float (* 半径 *)
  | Triangle of float * float (* 幅 * 高さ *)

let draw_figure x y fig =
  match fig with
    | Rectangle(n1, n2) -> fill_rect (int_of_float x) (int_of_float y) (int_of_float n1) (int_of_float n2)
    | Circle r -> fill_circle (int_of_float x) (int_of_float y) (int_of_float r)
    | Triangle(width, height) -> fill_poly [| (int_of_float x, int_of_float y); (int_of_float (x +. width),int_of_float y); (int_of_float x, int_of_float (y +. height) )|]
;;



let main x y c figure =
  let rec loop () =
    let status = Graphics.wait_next_event
      [Graphics.Key_pressed] in
    if status.Graphics.keypressed then ()
    else loop () in
  Graphics.open_graph " 100x100";
  set_color c;
  draw_figure x y figure;
  loop ();
  Graphics.close_graph ();;
