open Ecs
open Component_defs
open System_defs
open Level

let create name level =
  let e = Entity.create () in
  
  (* components *)
  ListBox.set e (Ground, Level.filter_to_listbox Ground level);
  Velocity.set e Vector.zero;
  Mass.set e infinity;
  Name.set e name;
  Surface.set e Texture.red;

  (* Systems *)
  Collision_S.register e;
  Draw_S.register e;
  e