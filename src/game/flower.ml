open Component_defs
open System_defs
open Level
open Ecs

let create name pos =
  let e = Entity.create () in
    
  (* Components *)
  ElementGrid.set e Flower; 
  Position.set e (Point pos);
  (* La fleur ne bouge pas *)
  Velocity.set e Vector.zero;
  Mass.set e 0.0;
  Box.set e Globals.unit_box;
  Name.set e name;
  Elasticity.set e 0.0;
  Friction.set e (-0.25);
  Surface.set e (Texture.create_image
    (Graphics.get_image 
      "resources/images/flower.png")
    Globals.unit_box.width
    Globals.unit_box.height
    );
  Resting.set e Entity.dummy;
      
  (* systems *)
  Collision_S.register e;
  Draw_system.add_entity e;
  e
    
let unregister_systems e =
  Collision_S.unregister e;
  Draw_system.remove_entity e;