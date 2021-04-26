open Ecs
open Component_defs
open System_defs
open Level

let create name level =
  let e = Entity.create () in
  
  (* components *)
  ElementGrid.set e Spike;
  Box.set e Globals.unit_box;
  Position.set e (MultiPoint 
    (Level.filter_to_listpos Spike level));
  Velocity.set e (Physical Vector.zero);
  Mass.set e infinity;
  Name.set e name;
  Surface.set e (Texture.create_image
    (Graphics.get_image 
      "resources/images/spike.png")
    Globals.unit_box.Rect.width
    Globals.unit_box.Rect.height
    );
  Elasticity.set e 0.0;
  Friction.set e (-0.25);

  (* Systems *)
  Collision_S.register e;
  Draw_S.register e;
  e