open Component_defs
open Vector

let ctx = ref None
let init () =
  let _, c = Gfx.create "game_canvas:800x600:"  in
  ctx := Some c

let draw ctx e x y =
  let box = Box.get e in 
  match Surface.get e with
  | Color(color) -> 
    Gfx.fill_rect ctx 
      (int_of_float x)
      (int_of_float y)
      box.width
      box.height
      color
  | Image(render) -> 
    Gfx.blit_scale ctx render
      (int_of_float x)
      (int_of_float y)
      box.width
      box.height
  | Animation(animation) ->
    let v = Velocity.get e in
    let render = Texture.get_frame animation (int_of_float v.x) in
    Gfx.blit_scale ctx render
      (int_of_float x)
      (int_of_float y)
      box.width
      box.height

let update _dt el =
  let ctx = Option.get !ctx in
  Gfx.clear_rect ctx 0 0 800 600;
  List.iter (fun e ->
    (* Faire décalage avec caméra pour le scroll *) 
    match Position.get e with
    | Point pos ->
        draw ctx e pos.x pos.y 
    | MultiPoint lpos ->
        List.iter (fun pos ->
          draw ctx e pos.x pos.y 
          ) lpos
  ) el
