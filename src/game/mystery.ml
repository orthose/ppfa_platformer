open Component_defs
open System_defs
open Level
open Ecs

let create name level =
  (* Parcours de tous les blocs mystère du niveau *)
  List.fold_left (fun acc Vector.{x = x; y = y} ->
    let e = Entity.create () in
    
    (* Components *)
    ElementGrid.set e (Mystery true); 
    Position.set e (Point {x = x; y = y});
    (* Le bloc mystère ne bouge pas mais nécessaire
    pour l'animation *)
    Velocity.set e Vector.{x = 0.5; y=0.0};
    Mass.set e infinity;
    Box.set e Globals.unit_box;
    Name.set e name;
    Elasticity.set e 0.0;
    Friction.set e (-0.25);
    Surface.set e (Texture.create_animation
      (Graphics.get_image 
        "resources/images/mystery.png")
      4 1
      17 16
      Globals.unit_box.width
      Globals.unit_box.height 100.
      );
    Resting.set e Entity.dummy;
      
    (* systems *)
    Collision_S.register e;
    Draw_S.register e;
    
    (* On ajoute à la liste des entités *)
    e :: acc
     
    ) [] (Level.filter_to_listpos (Mystery true) level)
    
let use dt e =
  (* Détermination du bonus *)
  let pos = Vector.sub 
    (match Position.get e with
    | Point p -> p
    | _ -> failwith "Mystery has only Point position")
    (Vector.{
      x = 0.0; 
      y = (float)Globals.unit_box.height})
  in
  let _ = 
    match Game_state.get_form () with
    | Small -> Mushroom.create dt "mushroom" pos
    | Big | Fire -> Flower.create "flower" pos
  in
  (* Désactivation du bloc mystère *)
  ElementGrid.set e (Mystery false);
  Surface.set e (Texture.create_image
    (Graphics.get_image
      "resources/images/mystery-disabled.png") 
    Globals.unit_box.width
    Globals.unit_box.height
    )