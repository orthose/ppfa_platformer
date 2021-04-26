open Ecs
open Component_defs
open System_defs
open Level

let create name level =
  let e = Entity.create () in
  
  (* components *)
  ElementGrid.set e Toadstool;
  Box.set e Globals.unit_box;
  Position.set e (MultiPoint 
    (Level.filter_to_listpos Toadstool level));
  Velocity.set e (Physical Vector.zero);
  Mass.set e infinity;
  Name.set e name;
  Surface.set e (Texture.create_image
    (Graphics.get_image 
      "resources/images/toadstool.png")
    Globals.unit_box.Rect.width
    Globals.unit_box.Rect.height
    );
  (* Effet de rebond en augmentant l'élasticité *)
  Elasticity.set e 0.95;
  Friction.set e (-0.25);

  (* Systems *)
  Collision_S.register e;
  Draw_S.register e;
  e