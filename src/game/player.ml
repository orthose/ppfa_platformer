open Component_defs
open System_defs
open Ecs

type action = { 
  mutable move_left : bool;
  mutable move_right : bool;
  mutable jump : bool;
  mutable right_left : bool;
  mutable fall : bool;
}

type player_sprite = {
  sprite : string;
  num_w : int;
  num_h : int;
  sw : int;
  sh : int
}

let action = { 
  move_left = false; move_right = false ; jump = false;
  (* Mémorise dans quel sens on avançait pour s'arrêter
  du bon côté au repos *) 
  right_left = true;
  (* Mémorise si le joueur est en train de tomber *)
  fall = false; }

(* Tableau des paramètres de sprites *)
let sprites = [|
  {
    sprite = "mario-pause-right.png";
    num_w = 1; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "mario-run-right.png";
    num_w = 3; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "mario-jump-right.png";
    num_w = 1; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "mario-pause-left.png";
    num_w = 1; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "mario-run-left.png";
    num_w = 3; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "mario-jump-left.png";
    num_w = 1; num_h = 1;
    sw = 17; sh = 32
  }
|]

let set_sprite i =
  let s = sprites.(i) in
  Surface.set (Game_state.get_player ()) (
    Texture.create_animation
    (Graphics.get_image 
      ("resources/images/"^s.sprite))
    s.num_w s.num_h
    s.sw s.sh
    Globals.player_box.width
    Globals.player_box.height
    )

let create name x y espike =
  let e = Entity.create () in
  Position.set e (Point { x = x; y = y});
  Velocity.set e Vector.zero;
  Mass.set e 10.;
  Box.set e Globals.player_box;
  Name.set e name;
  SumForces.set e Vector.zero;
  Resting.set e Entity.dummy;
  CollisionResolver. set e (fun dt _ e2 ->
    (* Le joueur est touché par un ennemi *)
    if Enemy.has_component e2  
    && dt -. (Game_state.get_dt_hit ()) > Globals.immortal_time then (
      (* On démarre le temps d'invincibilité *)
      Game_state.set_dt_hit dt;
      (* On fait diminuer la vie *)
      Game_state.decr_life ()
      )
    (* Le joueur touche une plateforme piquante 
    Il meurt instantanément ! *)
    else if e2 = espike then (
      (* On fait diminuer la vie *)
      Game_state.decr_life ()
      );
    (* Sprite de repos après un saut *)
    if (not action.jump) 
    && (not action.move_right) 
    && (not action.move_left) then (
      if action.right_left then set_sprite 0
      else set_sprite 3
      )
    );

  (* systems *)
  (* Le joueur est enregistré manuellement
  au système de collision *)
  (*Collision_S.register e;*)
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
  if action.jump && r <> Entity.dummy then begin
    (* On peut ici implémenter un double saut *)
    move Globals.jump;
    Resting.set (Game_state.get_player ()) Entity.dummy 
  end;
  (* Activation du sprite de course quand on touche le sol *)
  if action.fall && r <> Entity.dummy && (not action.jump) then (
    if action.move_left then set_sprite 4;
    if action.move_right then set_sprite 1;
    action.fall <- false;
    )

let jump () =
  if action.right_left then
    set_sprite 2
  else set_sprite 5;
  action.jump <- true
  
let run_left () =
  (* Sprite de course *)
  if (not action.jump) 
  && (not action.move_left) 
  && (not action.fall) then
    set_sprite 4
  (* Sprite de saut *)
  else if (action.jump || action.fall)
  && (not action.move_left) then
    set_sprite 5;
  action.move_left <- true;
  action.right_left <- false
  
let run_right () =
  (* Sprite de course *)
  if (not action.jump) 
  && (not action.move_right)
  && (not action.fall) then
    set_sprite 1
  (* Sprite de saut *)
  else if (action.jump || action.fall)
  && (not action.move_left) then
    set_sprite 2;
  action.move_right <- true;
  action.right_left <- true

let stop_jump () =
  action.fall <- true;
  action.jump <- false
  
let stop_run_left () =
  (* Sprite de repos *)
  if not action.jump then
    set_sprite 3;
  action.move_left <- false

let stop_run_right () = 
  (* Sprite de repos *)
  if not action.jump then
    set_sprite 0;
  action.move_right <- false
  
  