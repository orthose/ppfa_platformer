open Component_defs
open System_defs
open Ecs

type action = { 
  mutable move_left : bool;
  mutable move_right : bool;
  mutable jump : bool;
}

let action = { move_left = false; move_right = false ; jump = false}

let create name x y =
  let e = Entity.create () in
  Position.set e (Point { x = x; y = y});
  Velocity.set e Vector.zero;
  Mass.set e 10.;
  Box.set e Globals.player_box;
  Name.set e name;
  Surface.set e Texture.black;
  SumForces.set e Vector.zero;
  Resting.set e false;
  Friction.set e 0.0;

  (* systems *)
  Collision_S.register e;
  Control_S.register e;
  Draw_S.register e;
  Move_S.register e;
  Force_S.register e;
  e

let move fdir =
  let e = Game_state.get_player () in
    let old_f = SumForces.get e in
    let new_f = Vector.add fdir old_f in
    SumForces.set e new_f

let do_move () =
  let r = Resting.get (Game_state.get_player ()) in
  (* Si on teste r pour les mouvement horizontaux, on ne peut
     pas diriger le personnage en l'air : difficile de le contrôler
  *)
  if action.move_left then move Globals.left;
  if action.move_right then move Globals.right;
  if action.jump && r then begin
    (* On peut ici implémenter un double saut *)
    move Globals.jump;
    Resting.set (Game_state.get_player ()) false  
  end

let jump () = action.jump <- true
let run_left () = action.move_left <- true
let run_right () = action.move_right <- true

let stop_jump () = action.jump <-  false
let stop_run_left () = action.move_left <- false
let stop_run_right () = action.move_right <- false
  