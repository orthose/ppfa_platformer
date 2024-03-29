type t = { x : float ; y : float }
let add a b = { x = a.x +. b.x; y = a.y +. b.y }
let sub a b = { x = a.x -. b.x; y = a.y -. b.y }

let mult k a = { x = k*. a.x; y = k*. a.y }

let dot a b = a.x *. b.x +. a.y *. b.y
let norm a = sqrt (dot a a)
let normalize a = mult (1.0 /. norm a) a
let pp fmt a = Format.fprintf fmt "(%f, %f)" a.x a.y

(* Distance euclidienne *)
let dist u v = norm (sub u v)

let zero = { x = 0.0; y = 0.0 }
let is_zero v = v.x = 0.0 && v.y = 0.0

let random_x () = { 
  x = 
    (let r = Random.float 1.0 in
    if Random.bool () then r
    else (-. r));
    y = 0.0 }
let random_y () = 
  let r = random_x () in
  { x = 0.0; y = r.x }
let random_dir_x () = {
  x = if Random.bool () then 1.0 else -.1.0;
  y = 0.0
}
let random_dir_y () =
  let r = random_dir_x () in
  { x = 0.0; y = r.x }
