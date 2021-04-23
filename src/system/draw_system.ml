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
  ) el;
  
  (* Affichage du score *)
  Gfx.draw_text ctx
  (
    "🏆 "^string_of_int 
    (Game_state.get_score ())
  ) 
  (0 + 5) 35 "35px Arial" (
    select_color white
    );
    
  (* Affichage de la vie *)
  let life = Game_state.get_life () in
  (* Création du nombre de coeurs sous forme string *)
  let s = String.concat "" (List.init (
    (* Pour éviter erreur *)
    if life > 0 then life else 0
    ) (fun _ -> "❤")) in
  Gfx.draw_text ctx s
  (800 - (
    Gfx.measure_text ctx s
    "35px Arial"
  ) - 10) 35 "35px Arial" (
    (* Changement de couleur du score *)
    if (dt -. (Game_state.get_dt_hit ())) <= Globals.immortal_time then
      select_color blue
    else if life > 5 then select_color green
    else if life > 2 then select_color yellow
    else select_color red
    );
  
