open Component_defs
open System_defs
open Level
open Ecs

let remove e =
  Collision_S.unregister e;
  Draw_system.remove_entity e;
  Move_S.unregister e;
  Force_S.unregister e;
  Autopilot_S.unregister e;
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
    SumForces.delete e;
    Box.delete e;
    Name.delete e;
    Elasticity.delete e;
    Friction.delete e;
    Surface.delete e;
    Resting.delete e;
    Ai.delete e;
    Remove_S.unregister e
    );
  Remove_S.register e
  
let create dt_init name pos =
  let e = Entity.create () in
  
  (* Vitesse constante dont direction right ou left aléatoire *)
  let cte_velocity = Vector.mult 0.02 (Vector.random_dir_x ()) in
  (* Fonction de mouvement pour Autopilot *)
  let move e dt =
    (* Destruction automatique du champigon *)
    if dt -. dt_init >= Globals.lifespan_mushroom then
      remove e
    else
      let f = SumForces.get e in
      let new_f = Vector.add f cte_velocity in
      SumForces.set e new_f
  in
  (* Components *)
  ElementGrid.set e Mushroom; 
  Position.set e (Point pos);
  Velocity.set e Vector.zero;
  Mass.set e 10.0;
  SumForces.set e Vector.zero;
  Box.set e Globals.unit_box;
  Name.set e name;
  Elasticity.set e 0.0;
  Friction.set e (-0.25);
  Surface.set e (Texture.create_image
    (Graphics.get_image 
      "resources/images/mushroom.png")
    Globals.unit_box.width
    Globals.unit_box.height
    );
  Resting.set e Entity.dummy;
  Ai.set e (move e);
  
  (* systems *)
  Collision_S.register e;
  Draw_system.add_entity e;
  Move_S.register e;
  Force_S.register e;
  Autopilot_S.register e;
  e
    