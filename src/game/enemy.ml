open Component_defs
open System_defs
open Ecs

(* fmove est la fonction de déplacement
automatique de l'ennemi *)
let create name x y =
  let e = Entity.create () in
  Position.set e (Point { x = x; y = y});
  Velocity.set e Globals.right;
  Mass.set e 10.;
  Box.set e Globals.enemy_box;
  Name.set e name;
  Surface.set e Texture.gray;
  SumForces.set e Vector.zero;
  Resting.set e Entity.dummy;
  Enemy.set e e;
  CollisionResolver. set e (fun _ _ ->
      Velocity.set e (Vector.mult (-. 1.) (Velocity.get e))
    );
  
  (* systems *)
  Collision_S.register e;
  Draw_S.register e;
  Move_S.register e;
  Force_S.register e;
  e
  
(* Doit réaliser les déplacements 
de tous les ennemis *)
