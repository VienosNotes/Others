let rec qsort func list =
  match list with
    | [] -> []
    | b::rest ->
        let rec split list =
          match list with
            | [] -> ([], [])
            |  x::rest ->
                let (l1, l2) = split rest
                in if func x b then (x::l1, l2) else (l1, x::l2)
        in let (l1, l2) = split rest
           in qsort func l1@(b::qsort func l2);;


qsort (fun x y -> (x <= y)) [2; 1; 2; 3];;
qsort (fun x y -> x >= y) [4.0; 3.0; 7.0];;
