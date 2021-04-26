open Component_defs
open System_defs
open Level
open Ecs

let create name level =
  (* Parcours de tous les switchs du niveau *)
  List.fold_left (fun acc Vector.{x = x; y = y} ->
    let e = Entity.create () in
    
    (* Components *)
    ElementGrid.set e Switch; 
    Position.set e (Point {x = x; y = y});
    Velocity.set e (Physical Vector.zero);
    Mass.set e infinity;
    Box.set e Globals.unit_box;
    Name.set e name;
    Elasticity.set e 0.0;
    Friction.set e (-0.25);
    Surface.set e (Texture.create_image
      (Graphics.get_image 
        "resources/images/switch.png")
      Globals.unit_box.width
      Globals.unit_box.height
      );
    Resting.set e Entity.dummy;
      
    (* systems *)
    Collision_S.register e;
    Draw_S.register e;
    
    (* On ajoute à la liste des entités *)
    e :: acc
     
    ) [] (Level.filter_to_listpos Switch level)
    
let use e =
  (* Lors d'un appui sur le switch 
  on passe au niveau suivant *)
  Game_state.game_is_won ();
  Surface.set e (Texture.create_image
      (Graphics.get_image 
        "resources/images/switch-disabled.png")
      Globals.unit_box.width
      Globals.unit_box.height
      );






