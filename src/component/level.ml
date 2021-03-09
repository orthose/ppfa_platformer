(* Les différents types de plateforme *)
type platform =
  | Empty
  | Ground

(* Matrice des plateformes *)
type level = platform array array

(* Liste des positions de box *)
type listbox = Vector.t list

type t = platform * listbox

let filter token =
  Array.map (fun a ->
    Array.map (fun el ->
      if token = el then token
      else Empty
    ) a
  )
  
let filter_to_listbox platform level =
  ! (fst (
    Array.fold_left (fun acc1 a ->
      let _ =
        Array.fold_left (fun acc2 b ->
          if platform = b then
            let i = snd acc1 in
            let j = acc2 in
            let x = j * Globals.unit_width in
            let y = i * Globals.unit_height in
            fst acc1 := 
              Vector.{
                x = float_of_int x;
                y = float_of_int y;
              } 
              :: !(fst acc1);acc2 + 1
          else acc2 + 1
      ) 0 a 
    in
    (fst acc1, snd acc1 + 1)
  ) (ref [], 0) level))  