open Component_defs
open System_defs
open Level
open Ecs

let create name enemy velocity box texture mass life gravity level =
  (* Parcours de tous les ennemis du niveau *)
  List.fold_left (fun acc Vector.{x = x; y = y} ->
    let e = Entity.create () in
    
    (* Components *)
    Enemy.set e (Enemy enemy);
    Position.set e (Point {x = x; y = y});
    Velocity.set e velocity;
    Mass.set e mass;
    Box.set e box;
    Name.set e name;
    Elasticity.set e 1.0;
    Surface.set e texture;
    Resting.set e Entity.dummy;
    Life.set e life;
    CollisionResolver. set e (fun _ _ ->
      (* Changement de direction *)
      Velocity.set e (Vector.mult (-. 1.) (Velocity.get e))
      );
      
    (* systems *)
    Collision_S.register e;
    Draw_S.register e;
    Move_S.register e;
    
    (* L'ennemi est-il soumis à la gravité ? *)
    if gravity then
      SumForces.set e Vector.zero;
      Force_S.register e;
    
    (* On ajoute à la liste des entités *)
    e :: acc
     
    ) [] (Level.filter_to_listpos (Enemy enemy) level)
 