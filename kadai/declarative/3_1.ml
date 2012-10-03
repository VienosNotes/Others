(* 図形のデータ型 *)
type figure = 
  | Circle of float
  | Square of float
  | Rectangle of float * float;;

(* 面積を求める関数 *)
let area (x:figure) =
  match x with
    | Circle x -> x *. x *. 3.14
    | Square x -> x *. x
    | Rectangle ( x, y ) -> x *. y;;

print_float (area (Circle 2.));;
print_float (area (Square 2.));;
print_float (area (Rectangle(2.0, 3.0)));;
