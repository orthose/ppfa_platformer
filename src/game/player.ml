open Component_defs
open System_defs
open Ecs

let create name x y =
  let e = Entity.create () in
  Position.set e (Point { x = x; y = y});
  Velocity.set e Vector.zero;
  Mass.set e infinity;
  Box.set e Globals.player_box;
  Name.set e name;
  Surface.set e Texture.black;


  (* systems *)
  Collision_S.register e;
  Control_S.register e;
  Draw_S.register e;
  Move_S.register e;
  e

let reset e x y = 
  Position.set e (Point { x = x; y = y })

let move_up e =
  Velocity.set e { x = 0.0; y = -100.0 }
  
let move_down e =
  Velocity.set e { x = 0.0; y = 100.0 }

let stop e =
  Velocity.set e Vector.zero
  