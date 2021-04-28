open Component_defs
open System_defs
open Level
open Ecs

let remove e =
  Draw_system.remove_entity e;
  Move_S.unregister e;
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
    Box.delete e;
    Name.delete e;
    Elasticity.delete e;
    Friction.delete e;
    Surface.delete e;
    Resting.delete e;
    Ai.delete e;
    CollisionResolver.delete e;
    Remove_S.unregister e
    );
  Remove_S.register e

(* dir = true -> right | dir = false -> left *)  
let create name init_pos dir =
  let e = Entity.create () in
  
  (* Fonction de mouvement pour Autopilot *)
  let cte_velocity =
    if dir then Vector.{x = 0.3; y = 0.0}
    else Vector.{x = -.0.3; y = 0.0}
  in
  let distance = Globals.distance_fire in
  let test_remove =
    if dir then
      fun x -> init_pos.Vector.x +. distance <= x
    else
      fun x -> x <= init_pos.Vector.x -. distance
  in
  let move e dt =
    let duration = 
      (* Astuce nécessaire car on ne peut pas initialiser dt
      à partir de Player.fire *)
      match ElementGrid.get e with
      | Fire None -> 
          ElementGrid.set e (Fire (Some dt)); 0.0
      | Fire (Some dt_init) ->
          dt -. dt_init
      | _ -> failwith "Fire is not a fire"
    in
    let pos = 
      match Position.get e with
      | Point p -> p
      | _ -> failwith "Fire has only Point position"
    in
    (* Destruction automatique de la flamme *)
    if duration >= Globals.lifespan_fire
    || test_remove pos.Vector.x then remove e
    else
      Velocity.set e (Physical (Vector.add cte_velocity
        (Vector.mult 0.5 (Vector.random_y ()))
        ))
  in
  (* Components *)
  ElementGrid.set e (Fire None); 
  Position.set e (Point init_pos);
  (* Direction initialisée aléatoirement *)
  Velocity.set e (Physical cte_velocity);
  Mass.set e 0.0;
  Box.set e (Rect.{
    width = Globals.unit_box.width / 2;
    height = Globals.unit_box.height / 2});
  Name.set e name;
  Elasticity.set e 0.0;
  Friction.set e (-0.25);
  Surface.set e (Texture.create_image
    (Graphics.get_image (
      if dir then 
        "resources/images/fire-right.png"
      else
        "resources/images/fire-left.png"
      ))
    (Globals.unit_box.width / 2) 
    (Globals.unit_box.height / 2)
    );
  Resting.set e Entity.dummy;
  Ai.set e (move e);
  CollisionResolver.set e (fun dt side _ e2 ->
    match ElementGrid.get e2 with
    (* On touche goomba cela le tue instantanément *)
    | Enemy (Goomba (dt_hit, _)) -> 
        Goomba.remove e2;
        remove e
    (* On essaye de réduire au maximum les fuites mémoire *)
    | _ -> remove e
    );
  
  (* systems *)
  (* On enregistre à la main dans le système de Collision *)
  (*Collision_S.register e;*)
  Draw_system.add_entity e;
  Move_S.register e;
  Autopilot_S.register e;
  e