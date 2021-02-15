open Component_defs

let ctx = ref None
let init () =
  let _, c = Gfx.create "game_canvas:800x600:"  in
  ctx := Some c

let update _dt el =
  let ctx = Option.get !ctx in
  Gfx.clear_rect ctx 0 0 800 600;
  List.iter (fun e ->
    let pos = Position.get e in
    let box = Box.get e in
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
    ) el
