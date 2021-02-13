open Component_defs
open System_defs



let create name x y =
  let e = Entity.create () in
  Position.set e { x = x; y = y};
  Velocity.set e Vector.zero;
  Mass.set e infinity;
  Box.set e {width = Globals.paddle_width; height=Globals.paddle_height };
  Name.set e name;
  Surface.set e Texture.black;


  (* systems *)
  Collision_S.register e;
  Control_S.register e;
  Draw_S.register e;
  Move_S.register e;
  e

let reset e x y = 
  Position.set e { x = x; y = y }

let move_up e =
  if Game_state.get_turn () == Playing then
    Velocity.set e { x = 0.0; y = -100.0 }
  
let move_down e =
  if Game_state.get_turn () == Playing then
    Velocity.set e { x = 0.0; y = 100.0 }

let stop e =
  Velocity.set e Vector.zero
  