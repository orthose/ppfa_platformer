open Level

(* Lien string -> constructeur *)
let link = function
  | '-' -> Empty
  | '*' -> Ground
  | _ -> failwith "Unknown token"

let parse level_file =
  let file = open_in level_file in
  
  (* Initialisation *)
  let first = 
    try
      input_line file
    with End_of_file ->
      let () = close_in file in
      failwith "Empty level file or empty first line"
  in
  
  let w = String.length first in
  
  (* Parcours de chaque line construit une liste de lignes *)
  let rec list_of_lines acc =
    try
      let line = input_line file in
      if String.length line <> w then
        failwith "Parsing error inconsistent format for line width"
      else
        list_of_lines (
          line :: (fst acc),
          1 + (snd acc)
        )
    with End_of_file -> 
      let () = close_in file in acc
  in
  let (lol, h) = list_of_lines ([first], 1) in
  
  let res = Array.make_matrix h w Empty in
  
  (* Remplissage de la matrice *)
  List.iteri (fun i s ->
    String.iteri (fun j c ->
      res.(h - 1 - i).(j) <- link c
    ) s
  ) lol; res