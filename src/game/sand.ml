open Ecs
open Component_defs
open System_defs
open Level

let create name level =
  let e = Entity.create () in
  
  (* components *)
  ElementGrid.set e Sand;
  Box.set e Globals.unit_box;
  Position.set e (MultiPoint 
    (Level.filter_to_listpos Sand level));
  Velocity.set e (Physical Vector.zero);
  Mass.set e infinity;
  Name.set e name;
  Surface.set e (Texture.create_image
    (Graphics.get_image 
      "resources/images/sand.png")
    Globals.unit_box.Rect.width
    Globals.unit_box.Rect.height
    );
  Elasticity.set e 0.0;
  Friction.set e (-.0.75);

  (* Systems *)
  Collision_S.register e;
  Draw_S.register e;
  e