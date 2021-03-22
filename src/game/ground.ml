open Ecs
open Component_defs
open System_defs
open Level

let create name level =
  let e = Entity.create () in
  
  (* components *)
  Platform.set e Ground;
  Box.set e Globals.unit_box;
  Position.set e (MultiPoint 
    (Level.filter_to_listbox Ground level));
  Velocity.set e Vector.zero;
  Mass.set e infinity;
  Name.set e name;
  Surface.set e Texture.red;
  Elasticity.set e 0.0;
  Friction.set e (-0.25);

  (* Systems *)
  Collision_S.register e;
  Draw_S.register e;
  e