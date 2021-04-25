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
      Globals.unit_box.height
      Globals.rate_coin
      );
    Resting.set e Entity.dummy;
      
    (* systems *)
    Collision_S.register e;
    Draw_S.register e;
    
    (* On ajoute à la liste des entités *)
    e :: acc
     
    ) [] (Level.filter_to_listpos Coin level)
    
let remove e =
  Collision_S.unregister e;
  Draw_S.unregister e;
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