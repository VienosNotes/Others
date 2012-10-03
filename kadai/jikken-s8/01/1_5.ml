let rec quicksort l =
  match l with
    | pivot::rest -> let less, greater = List.partition (fun x -> x < pivot) rest in
                     quicksort less @ [pivot] @ quicksort greater
    | _ -> [];;

quicksort [14;5;13;5;7;3;1;32;52;7];;
