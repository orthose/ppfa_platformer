(* Les différents types d'éléments de la grille de niveau *)
type enemy =
  | Goomba of float
  | Boo

type t =
  (* Plateformes *)
  | Empty
  | Ground
  | Ice
  | Toadstool
  | Sand
  | Spike
  | Mystery of bool
  | Switch
  (* Items *)
  | Mushroom
  | Flower
  | Coin
  (* Ennemis *)
  | Enemy of enemy
  (* Projectiles *)
  | Fire of float option

(* Matrice des plateformes *)
type level = t array array 

(* Variables initialisées dans Level_parser *)
let width_max = ref 0.0
let height_max = ref 0.0

let filter token =
  Array.map (fun a ->
    Array.map (fun el ->
      if token = el then token
      else Empty
    ) a
  )
  
let filter_to_listpos platform level =
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