open Component_defs

let ctx = ref None
let init () =
  let _, c = Gfx.create "game_canvas:800x600:"  in
  ctx := Some c

let draw ctx e (pos:Vector.t) (box:Rect.t) =
  match Surface.get e with
  | Color(color) -> 
    Gfx.fill_rect ctx 
      (int_of_float pos.x)
      (int_of_float pos.y)
      box.width
      box.height
      color
  | Image(render) -> 
    Gfx.blit_scale ctx render
      (int_of_float pos.x)
      (int_of_float pos.y)
      box.width
      box.height
  | Animation(animation) ->
    let v = Velocity.get e in
    let render = Texture.get_frame animation (int_of_float v.x) in
    Gfx.blit_scale ctx render
      (int_of_float pos.x)
      (int_of_float pos.y)
      box.width
      box.height

let update _dt el =
  let ctx = Option.get !ctx in
  Gfx.clear_rect ctx 0 0 800 600;
  List.iter (fun e ->
    if ListBox.has_component e then
      List.iter (fun pos ->
        draw ctx e pos Globals.unit_box
      ) (snd (ListBox.get e))
    else
      let pos = Position.get e in
      let box = Box.get e in
      draw ctx e pos box
  ) el
