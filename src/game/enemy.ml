(*open Component_defs
open System_defs*)
open Ecs

(* fmove est la fonction de déplacement
automatique de l'ennemi *)
let create _name _x _y _fmove =
  Entity.dummy
  
(* Doit réaliser les déplacements 
de tous les ennemis *)
let do_move () = ()