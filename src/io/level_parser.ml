type t =
  | Empty
  | Ground

(* Lien string -> constructeur *)
let link = function
  | "-" -> Empty
  | "*" -> Ground
  | _ -> failwith "Unknown token"

let parse level =
  let file = open_in level in
  
  (* Initialisation *)
  let first = 
    try
      input_line file
    with End_of_file ->
      let () = close_in file in
      failwith "Empty level file"
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
          (fun r -> (fst acc) ((Str.split (Str.regexp "") line) :: r)),
          1 + (snd acc)
        )
    with End_of_file -> 
      let () = close_in file in 
      let (cps, h) = acc in
      (cps [], h)
  in
  let (lol, h) = list_of_lines (
    (fun x -> (Str.split (Str.regexp "") first) :: x), 1) in
  
  let res = Array.make_matrix h w Empty in
  
  (* Remplissage de la matrice *)
  List.iteri (fun i l ->
    List.iteri (fun j x ->
      res.(i).(j) <- link x
    ) l
  ) lol; res
  
let filter token =
  Array.map (fun a ->
    Array.map (fun el ->
      if token = el then token
      else Empty
    ) a
  )
  
  
  
  
  
  
  
  
  