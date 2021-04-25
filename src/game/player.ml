open Component_defs
open System_defs
open Ecs
open Side

type action = { 
  mutable move_left : bool;
  mutable move_right : bool;
  mutable jump : bool;
  mutable move_fall : bool;
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
  move_left = false; move_right = false ; jump = false; move_fall = false;
  (* Mémorise dans quel sens on avançait pour s'arrêter
  du bon côté au repos *) 
  right_left = true;
  (* Mémorise si le joueur est en train de tomber *)
  fall = false; }

(* Tableau des paramètres de sprites *)
let sprites = [|
  (* Mario Big sprites[0-5]*)
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
  };
  (* Mario Small sprites[6-11] *)
  {
    sprite = "small-mario-pause-right.png";
    num_w = 1; num_h = 1;
    sw = 16; sh = 16
  };
  {
    sprite = "small-mario-run-right.png";
    num_w = 3; num_h = 1;
    sw = 16; sh = 16
  };
  {
    sprite = "small-mario-jump-right.png";
    num_w = 1; num_h = 1;
    sw = 16; sh = 16
  };
  {
    sprite = "small-mario-pause-left.png";
    num_w = 1; num_h = 1;
    sw = 16; sh = 16
  };
  {
    sprite = "small-mario-run-left.png";
    num_w = 3; num_h = 1;
    sw = 16; sh = 16
  };
  {
    sprite = "small-mario-jump-left.png";
    num_w = 1; num_h = 1;
    sw = 16; sh = 16
  };
  (* Mario Fire sprites[12-17] *)
  {
    sprite = "fire-mario-pause-right.png";
    num_w = 1; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "fire-mario-run-right.png";
    num_w = 3; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "fire-mario-jump-right.png";
    num_w = 1; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "fire-mario-pause-left.png";
    num_w = 1; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "fire-mario-run-left.png";
    num_w = 3; num_h = 1;
    sw = 17; sh = 32
  };
  {
    sprite = "fire-mario-jump-left.png";
    num_w = 1; num_h = 1;
    sw = 17; sh = 32
  };
|]

let set_sprite i =
  let s = sprites.(i +
    (* Décalage dans sprites *)
    match Game_state.get_form () with
    | Big -> 0
    | Small -> 6
    | Fire -> (6 * 2)
    ) in
  Surface.set (Game_state.get_player ()) (
    Texture.create_animation
    (Graphics.get_image 
      ("resources/images/"^s.sprite))
    s.num_w s.num_h
    s.sw s.sh
    Globals.player_box.width
    Globals.player_box.height 25.
    )

let create name x y =
  let e = Entity.create () in
  Position.set e (Point { x = x; y = y});
  Velocity.set e Vector.zero;
  Mass.set e 10.;
  Box.set e Globals.player_box;
  Name.set e name;
  SumForces.set e Vector.zero;
  Resting.set e Entity.dummy;
  CollisionResolver. set e (fun dt side _ e2 ->
    match ElementGrid.get e2 with
    (* Écrasement de Goomba *)
    | Enemy (Goomba dt_hit) when side = Top ->
        if dt -. dt_hit >= 1000. then 
          Goomba.flatten dt e2
    (* Le joueur est touché par un ennemi *)
    | Enemy _ ->
        if dt -. (Game_state.get_dt_hit ()) 
        > Globals.immortal_time then (
          (* On change l'état de Mario *)
          Game_state.set_form (
            match Game_state.get_form () with
            | Small ->
                Box.set e Globals.unit_box;
                Small
            | Big ->
                Box.set e Globals.unit_box;
                Small
            | Fire -> Big
            );
          (* On démarre le temps d'invincibilité *)
          Game_state.set_dt_hit dt;
          (* On fait diminuer la vie *)
          Game_state.decr_life ()
          )
    (* Le joueur touche une plateforme piquante 
    Il meurt instantanément ! *)
    | Spike -> 
        (* On fait diminuer la vie *)
        Game_state.decr_life ()
    (* Récupération d'une pièce *)
    | Coin ->
        Game_state.incr_score ();
        Coin.unregister_systems e2
    (* Activation bloc mystère *)
    | Mystery true ->
        if side = Down then Mystery.use dt e2
    (* Récupération de champigon *)
    | Mushroom ->
        (* Petit calcul de correction de position
        pour éviter de rester coincer dans une plateforme *)
        if Game_state.get_form () = Small then
          let pos = 
            match Position.get e with 
            | Point p -> p
            | _ -> failwith "Player has only Point position" 
          in
          Position.set e (Point
            (Vector.sub pos Vector.{
              x = 0.0;
              y = float_of_int (
                    Globals.player_box.height
                    - Globals.unit_box.height
                    )})
              );
        Game_state.set_form Big;
        Game_state.incr_score ();
        Game_state.reset_life ();
        Mushroom.unregister_systems e2;
        Box.set e Globals.player_box
    (* Récupération de fleur *)
    | Flower -> 
        Game_state.set_form Fire;
        Game_state.incr_score ();
        Game_state.reset_life ();
        Flower.unregister_systems e2;
        Box.set e Globals.player_box
    | _ -> ()
    ;
    
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
  if action.move_fall then move Globals.down;
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
  
let fall () =
  action.move_fall <- true
  
let stop_fall () =
  action.move_fall <- false
  
let fire () =
  if Game_state.get_form () = Fire then
    let pos = 
      match Position.get (Game_state.get_player ()) with
        | Point p ->
          Vector.add p Vector.{ x = 
            (if action.right_left then 1.0 else -.1.0) 
            *. (match Game_state.get_form () with 
            | Small -> (float)Globals.unit_box.width
            | Big | Fire -> (float)Globals.player_box.width);
            y = (float)Globals.unit_box.height /. 2.}
        | _ -> failwith "Player has only Point position"
      in
      let _ = Fire.create "fire" pos action.right_left in ()
  