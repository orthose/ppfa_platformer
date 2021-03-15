(* Les différents types de plateforme *)
type t =
  | Empty
  | Ground

(* Matrice des plateformes *)
type level = t array array

let filter token =
  Array.map (fun a ->
    Array.map (fun el ->
      if token = el then token
      else Empty
    ) a
  )
  
let filter_to_listbox platform level =
  let (w, h) = (Globals.unit_box.width, Globals.unit_box.height) in
  ! (fst (
    Array.fold_left (fun acc1 a ->
      let _ =
        Array.fold_left (fun acc2 b ->
          if platform = b then
            let i = snd acc1 in
            let j = acc2 in
            let x = j * w in
            let y = i * h in
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