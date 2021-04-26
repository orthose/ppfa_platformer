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
    Velocity.set e (Physical velocity);
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
    
let remove e gravity =
    Collision_S.unregister e;
    Draw_S.unregister e;
    Move_S.unregister e;
    Autopilot_S.unregister e;
    if gravity then
      Force_S.unregister e;
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
      Life.delete e;
      Ai.delete e;
      if gravity then 
        SumForces.delete e;
      Remove_S.unregister e
    );
    Remove_S.register e
 