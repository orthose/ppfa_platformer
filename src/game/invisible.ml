open Ecs
open Component_defs
open System_defs
open Level

let create name level =
  let e = Entity.create () in
  
  (* components *)
  ElementGrid.set e Invisible;
  Box.set e Globals.unit_box;
  Position.set e (MultiPoint 
    (Level.filter_to_listpos Invisible level));
  Velocity.set e (Physical Vector.zero);
  Mass.set e infinity;
  Name.set e name;
  Surface.set e (Texture.invisible);
  Elasticity.set e 0.0;
  Friction.set e 0.0;

  (* Systems *)
  Collision_S.register e;
  Draw_S.register e;
  e