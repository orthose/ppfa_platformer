open Component_defs
open System_defs
open Ecs

let random_dir tmin tmax n =
  let t = tmin +. Random.float (tmax -. tmin) in
  let x = n *. cos t in
  let y = n *. sin t in
  Vector.{ x = x; y = y}
let pi = 2. *. asin 1.0


let create name x y sprite =
  let e = Entity.create () in
  (* components *)
  Position.set e {x = x; y = y };
  Box.set e {width = 20 ; height = 20};
  Velocity.set e { x = 0.0; y = 0.0 };
  Mass.set e 10.0;
  Name.set e name;
  Surface.set e (
    Texture.create_animation
      sprite 4 9 170 170 
      Globals.ball_size 
      Globals.ball_size
  );
  

  (* systems *)
  Collision_S.register e;
  Control_S.register e;
  Move_S.register e;
  Draw_S.register e;
  e

let reset e x y  =
  Velocity.set e { x = 0.0; y = 0.0 };
  Position.set e { x = x; y = y}


let launch e =
    match Game_state.get_turn () with
    Playing -> ()
    | Player1Lost ->
      let v = random_dir (~-.pi/. 3.0) (pi /. 3.0) 200.0 in
      Velocity.set e v;
      Game_state.play()
    | Player2Lost ->
      let v = random_dir (2.0 *. pi/. 3.0) (4.0 *. pi /. 3.0) 200.0 in
      Velocity.set e v;
      Game_state.play()
