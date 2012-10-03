let rec split l =
  match l with
    | [] -> ([], [])
    | [x] -> ([x], [])
    | x1::x2::rest ->
        let (x1rest, x2rest) = split rest in
        (x1::x1rest, x2::x2rest);;

split [1; 2; 3; 4; 5; 6;];;


let rec merge func l1 l2 =
  match (l1, l2) with
    | ([], _) -> l2
    | (_, []) -> l1
    | (head1::rest1, head2::rest2) ->
        if func head1 head2 then
          head1::(merge func rest1 l2)
        else
          head2::(merge func l1 rest2);;


merge (fun x y -> x <= y) [1; 3; 5] [2;3;4];;

let rec msort f l =
  match l with
    | [] -> []
    | [x] -> [x]
    | _ -> let (half1, half2) = split l in
           merge f (msort f half1) (msort f half2);;

msort (fun x y -> x <= y) [5; 3; 1; 7; 6; 4];;

