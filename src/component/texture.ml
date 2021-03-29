type animation = {
  frames : Gfx.render array;
  mutable current : int
}

type t = Color of Gfx.color
  | Image of Gfx.render
  | Animation of animation

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
  
let create_animation img num_w num_h sw sh dw dh =
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
  Animation ({frames=frames; current=0})
  
let get_frame anim dir =
  let res = anim.frames.(anim.current) in
  let signe = 
    if dir == 0 then 0 
    else (abs dir) / dir
  in
  let length = Array.length anim.frames in
  let new_index = anim.current + signe in
  let borne n x = (n + x) mod n in
  (*let () = 
    if new_index < 0 then 
      anim.current <- length - 1
    else if length <= new_index then
      anim.current <- 0
    else anim.current <- new_index
  in*)
  anim.current <- borne length new_index;
  res
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          