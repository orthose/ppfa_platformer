open Component_defs

(* Renvoie les coordonnées corrigées pour le scrolling *)
let scrolling pos =
  let player = Game_state.get_player () in
  let Vector.{x = xp; y = yp} =
    match Position.get player with
    | Point(p) -> p
    | _ -> failwith "Player has only Point position"
  in
  let xr =
    (* Cas limite début niveau *)
    if xp < ((float)Globals.canvas_width 
      -. (float)Globals.player_box.width) /. 2. then 0.0
    (* Cas limite fin niveau *)
    else if xp > !Level.width_max -. (((float)Globals.canvas_width 
      +. (float)Globals.player_box.width) /. 2.) then 
      !Level.width_max -. (float)Globals.canvas_width
    else
      xp +. ((float)Globals.player_box.width /. 2.) 
      -. ((float)Globals.canvas_width /. 2.) in
  let yr = 
    if Globals.y_scroll then
      yp +. ((float)Globals.player_box.height /. 2.) 
      -. ((float)Globals.canvas_height /. 2.)
    else 0.0
  in
  Vector.{
    x = pos.x -. xr; 
    y = pos.y -. yr
  }
  
  
  
  
  