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
  Velocity.set e (Physical Vector.zero);
  Mass.set e infinity;
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
    
let remove e =
  Collision_S.unregister e;
  Draw_system.remove_entity e;
  (* Pour éviter bogue quand on saute sur l'objet
  et qu'il disparaît *)
  List.iter (fun (k, v) ->
    if v = e then Resting.set k Entity.dummy
    ) (Resting.members ());
  Remove.set e (fun () ->
    ElementGrid.delete e;
    Position.delete e;
    Velocity.delete e;
    Mass.delete e;
    Box.delete e;
    Name.delete e;
    Elasticity.delete e;
    Friction.delete e;
    Surface.delete e;
    Resting.delete e;
    Remove_S.unregister e
    );
  Remove_S.register e