open Component_defs
open System_defs

(* All our objects *)
(*
  Our canvas will be 800 x 600
  paddles : 20x50
  walls 800x20
  invisible walls behind the paddles 40x560

  For each object we associate components and systems.
*)

let create_paddle name x y x' y' kup kdown =
  let e = Entity.create () in
  (* components *)
  Position.set e { x = x; y = y};
  Box.set e {width = 20; height=80 };
  Name.set e name;
  Surface.set e Color.black;
  Score.set e (0, {x = x'; y = y'});
  PC.set e [ (kup, Move_Up); (kdown, Move_Down)];

  (* systems *)
  Logic_S.register e;
  Control_S.register e;
  Draw_S.register e


let create_wall name x y =
  let e = Entity.create () in

  (* components *)
  Position.set e { x = x; y = y};
  Box.set e {width = 800; height=20 };
  Name.set e name;
  Surface.set e Color.red;

  (* Systems *)
  Logic_S.register e;
  Draw_S.register e


let create_inv_wall name x y =
  let e = Entity.create () in
  (* components *)
  Position.set e { x = x; y = y};
  Box.set e {width = 40; height=560 };
  Name.set e name;

  (* systems *)
  Logic_S.register e
  
let create_net name x y =
  let e = Entity.create () in
  
  (* components *)
  Position.set e { x = x; y = y};
  Box.set e {width = 20; height=600 };
  Surface.set e Color.grey;
  Name.set e name;

  (* systems *)
  Draw_S.register e

let create_ball x y =
  let e = Entity.create () in
  (* components *)
  Position.set e {x = x; y = y };
  Box.set e {width = 20 ; height = 20};
  Velocity.set e { x = 0.0; y = 0.0 };
  PC.set e [ ("n", Launch) ];
  Name.set e "ball";
  Surface.set e Color.blue;

  (* systems *)
  Logic_S.register e;
  Control_S.register e;
  Move_S.register e;
  Draw_S.register e

let player1 = create_paddle "player1" 40.0 260.0 ((1. /. 4.) *. 800.) ((1. /. 2.) *. 600.) "w" "s"
let player2 = create_paddle "player2" 740.0 260.0 ((3. /. 4.) *. 800.) ((1. /. 2.) *. 600.) "i" "k"
let wall_top = create_wall "wall_top" 0.0 0.0
let wall_bottom = create_wall "wall_bottom" 0.0 580.0

let iwall_left = create_inv_wall "wall_left" 0.0 20.0
let iwall_rght = create_inv_wall "wall_right" 760.0 20.0

let net = create_net "middle_net" (800. /. 2.0) 0.0

let ball = create_ball 70.0 290.0


(* Now our systems *)
let init () = System.init_all ()

let update dt =
  (* Update all systems *)
  System.update_all dt;
  (* Repeat indefinitely *)
  true

let update_loop () = Gfx.main_loop update

let () =
  init ();
  update_loop ()
