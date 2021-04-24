open Component_defs
open System_defs
open Level
open Ecs

let create name level =
  (* Parcours de toutes les pièces du niveau *)
  List.fold_left (fun acc Vector.{x = x; y = y} ->
    let e = Entity.create () in
    
    (* Components *)
    ElementGrid.set e Coin; 
    Position.set e (Point {x = x; y = y});
    (* La pièce ne bouge pas mais nécessaire
    pour l'animation *)
    Velocity.set e Vector.{x = 0.5; y=0.0};
    Mass.set e 0.0;
    Box.set e Globals.unit_box;
    Name.set e name;
    Elasticity.set e 0.0;
    Friction.set e (-0.25);
    Surface.set e (Texture.create_animation
      (Graphics.get_image 
        "resources/images/coin.png")
      32 1
      33 34
      Globals.unit_box.width
      Globals.unit_box.height 25.
      );
    Resting.set e Entity.dummy;
      
    (* systems *)
    Collision_S.register e;
    Draw_S.register e;
    
    (* On ajoute à la liste des entités *)
    e :: acc
     
    ) [] (Level.filter_to_listpos Coin level)
    
let unregister_systems e =
  Collision_S.unregister e;
  Draw_S.unregister e