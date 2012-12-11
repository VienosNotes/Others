open Graphics;;

type figure =
Rectangle of float * float (* 幅 * 高さ *)
  | Circle of float (* 半径 *)
  | Triangle of float * float (* 幅 * 高さ *)
;;

let draw_figure x y scale fig =
  match fig with
    | Rectangle(n1, n2) -> fill_rect (int_of_float x) (int_of_float y) (int_of_float (scale *. n1)) (int_of_float (scale *. n2))
    | Circle r -> fill_circle (int_of_float x) (int_of_float y) (int_of_float (scale *. r))
    | Triangle(width, height) -> fill_poly [| (int_of_float x, int_of_float y); (int_of_float (x +. (scale *. width)),int_of_float y); (int_of_float x, int_of_float (y +. (scale *. height)))|]
;;

type region =
Figure of figure
  | Translate of float * float * region (* 図形を x 座標，y 座標で指定される位置に移動 *)
  | Scale of float * region (* float で指定される倍率で，図形を縮小拡大 *)
  | Union of region * region (* 二つの図形が合わさった図形 *)
;;

type picture = (Graphics.color * region) list
;;

let rec draw_region x y scale region =
  match region with
    | Figure(fig) -> draw_figure x y scale fig
    | Translate(x, y, reg) -> draw_region x y scale reg
    | Scale(scale, reg) -> draw_region x y scale reg
    | Union(reg1, reg2) -> draw_region x y scale reg1; draw_region x y scale reg2
;;

let draw_picture pic =
  List.fold_right (
    fun next prev ->
      match next with
        | (c, reg) -> set_color c; draw_region 0.0 0.0 1.0 reg
  ) pic ();;
          
let ex =
  let circle = Figure (Circle 25.) in
  let r1 = Union (Translate (25.,60., circle),
                  Translate (75.,60., circle)) in
  let rectangle = Figure (Rectangle (50., 50.)) in
  let r2 = Translate (25., 0., rectangle) in
  [(Graphics.black, r1); (Graphics.red, r2)]
;;


        
let main p =
  let rec loop () =
    let status = Graphics.wait_next_event
      [Graphics.Key_pressed] in
    if status.Graphics.keypressed then ()
    else loop () in
  Graphics.open_graph " 100x100";
  draw_picture p;
  loop ();
  Graphics.close_graph ()
;;


let mypict =
  let circle = Figure (Circle 25.) in
  let r1 = Union (Translate (25.,60. ,Scale(1.25, circle)),
            Translate (75.,60. ,Scale(0.75, circle))) in
  let rectangle = Figure (Rectangle (50., 50.)) in
  let triangle = Figure (Triangle(35., 35.)) in
  let r2 = Union(Translate( 25., 0., rectangle),
                 Translate( 75., 75., Scale(0.25, triangle))) in
  [(Graphics.green, r1); (Graphics.blue, r2)]
;;
