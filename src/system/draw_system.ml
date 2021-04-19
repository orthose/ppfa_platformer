open Component_defs
open Texture
open Vector

let ctx = ref None
let init () =
  let _, c = Gfx.create "game_canvas:800x600:"  in
  ctx := Some c

let draw dt ctx e x y =
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
    let render = Texture.get_frame dt animation v.x in
    Gfx.blit_scale ctx render
      (int_of_float x)
      (int_of_float y)
      box.width
      box.height

let update dt el =
  let ctx = Option.get !ctx in
  Gfx.clear_rect ctx 0 0 800 600;
  
  (* Affichage du score *)
  Gfx.draw_text ctx
  (
    string_of_int 
    (Game_state.get_score ())
  ) 
  (0 + 5) 25 "30px Arial" (
    select_color black
    );
    
  (* Affichage de la vie *)
  let life = Game_state.get_life () in
  let s = string_of_int life in
  Gfx.draw_text ctx s
  (800 - (
    Gfx.measure_text ctx s
    "30px Arial"
  ) - 5) 25 "30px Arial" (
    (* Changement de couleur du score *)
    if life > 5 then select_color green
    else if life > 1 then select_color yellow
    else select_color red
    );
    
  List.iter (fun e ->
    (* Faire décalage avec caméra pour le scroll *) 
    match Position.get e with
    | Point pos ->
        let scroll_pos = 
          Camera.scrolling pos
        in
        draw dt ctx e scroll_pos.x scroll_pos.y 
    | MultiPoint lpos ->
        List.iter (fun pos ->
          let scroll_pos = 
            Camera.scrolling pos
          in
          draw dt ctx e scroll_pos.x scroll_pos.y 
          ) lpos
  ) el
