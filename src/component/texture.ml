type animation = {
  frames : Gfx.render array;
  mutable current : int;
  mutable dt : float;
  refresh_dt : float;
}

type t = Color of Gfx.color
  | Image of Gfx.render
  | Animation of animation

let white = Color (Gfx.color 255 255 255 255)
let black = Color (Gfx.color 0 0 0 255)
let red = Color (Gfx.color 255 0 0 255)
let blue = Color (Gfx.color 0 0 255 255)
let green = Color (Gfx.color 0 255 0 255)
let yellow = Color (Gfx.color 255 255 0 255)
let gray = Color (Gfx.color 128 128 128 255)

let select_color c =
  match c with
  | Color(x) -> x
  | _ -> failwith "Invalid color"

let create_image img width height = 
  let render = Gfx.create_offscreen width height in
  let () = Gfx.draw_image_scale render img 0 0 width height in
  Image (render)
  
let create_animation img num_w num_h sw sh dw dh refresh_dt =
  let frames = Array.init (num_w * num_h) 
    (fun _ -> Gfx.create_offscreen dw dh) in
  let rec fill i j =
    if i < num_h then (
      if j < num_w then
        let () = 
          Gfx.draw_image_full frames.((i * num_w) + j) img
            (j * sw) (i * sh) sw sh 0 0 dw dh 
        in
        fill i (j + 1)
      else fill (i + 1) 0
    )
    else ()
  in
  let () = fill 0 0 in
  Animation ({frames=frames; current=0; dt = 0.; refresh_dt = refresh_dt})
  
let get_frame dt anim dir =
  let res = anim.frames.(anim.current) in
  let length = Array.length anim.frames in
  let borne n x = (n + x) mod n in
  (* Permet de ne pas avoir une animation trop rapide *)
  if dt -. anim.dt >= anim.refresh_dt then 
  begin
    anim.dt <- dt;
    (* On incrémente la frame que si l'objet bouge *)
    let new_index = anim.current + (
      (* On ne prend pas en compte les négatifs *)
      if dir > 0.0 then 1 else 0
      ) in
    anim.current <- borne length new_index
  end;
  res
  
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          