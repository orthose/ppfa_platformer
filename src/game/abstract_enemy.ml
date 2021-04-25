open Component_defs
open System_defs
open Level
open Ecs

let create name enemy velocity box texture mass life gravity move level =
  (* Parcours de tous les ennemis du niveau *)
  List.fold_left (fun acc Vector.{x = x; y = y} ->
    let e = Entity.create () in
    
    (* Components *)
    ElementGrid.set e (Enemy enemy);
    Position.set e (Point {x = x; y = y});
    Velocity.set e velocity;
    Mass.set e mass;
    Box.set e box;
    Name.set e name;
    Elasticity.set e 1.0;
    (* Friction dans le cas où le joueur marche
    sur l'ennemi *)
    Friction.set e (-.0.25);
    Surface.set e texture;
    Resting.set e Entity.dummy;
    Life.set e life;
    Ai.set e (move Vector.{x = x; y = y} e);
      
    (* systems *)
    Collision_S.register e;
    Draw_S.register e;
    Move_S.register e;
    Autopilot_S.register e;
    
    (* L'ennemi est-il soumis à la gravité ? *)
    if gravity then (
      SumForces.set e Vector.zero;
      Force_S.register e
      );
    
    (* On ajoute à la liste des entités *)
    e :: acc
     
    ) [] (Level.filter_to_listpos (Enemy enemy) level)
    
let unregister_systems e gravity =
    Collision_S.unregister e;
    Draw_S.unregister e;
    Move_S.unregister e;
    Autopilot_S.unregister e;
    if gravity then
      Force_S.unregister e
 