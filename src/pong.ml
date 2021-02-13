(* All our objects *)

let bg_img = Gfx.load_image "./images/clay.png"
let ball_img = Gfx.load_image "./images/ball_frames.png"

let load_graphics _dt = 
  not (Gfx.image_ready bg_img
    && Gfx.image_ready ball_img)

let player1 =
  Player.create "player1" Globals.player1_init_x Globals.player_init_y
let player2 =
  Player.create "player2" Globals.player2_init_x Globals.player_init_y
let wall_top = Wall.create "wall_top" 0.0 0.0
let wall_bottom = Wall.create "wall_bottom" 0.0 580.0
let iwall_left = Score_zone.create "wall_left" player2 0.0 20.0
let iwall_rght = Score_zone.create "wall_right" player1 760.0 20.0

let init_game _dt = 
  System.init_all ();
  let ball = Ball.create "ball" 
    Globals.ball_player1_init_x 
    Globals.ball_init_y 
    ball_img
  in
  let _bg = Bg.create bg_img in
  
  Input_handler.register_command (KeyDown "w") (fun () -> Player.move_up player1);
  Input_handler.register_command (KeyDown "s") (fun () -> Player.move_down player1);
  Input_handler.register_command (KeyUp "w") (fun () -> Player.stop player1);
  Input_handler.register_command (KeyUp "s") (fun () -> Player.stop player1);

  Input_handler.register_command (KeyDown "i") (fun () -> Player.move_up player2);
  Input_handler.register_command (KeyDown "k") (fun () -> Player.move_down player2);
  Input_handler.register_command (KeyUp "i") (fun () -> Player.stop player2);
  Input_handler.register_command (KeyUp "k") (fun () -> Player.stop player2);

  Input_handler.register_command (KeyDown "n") (fun () -> Ball.launch ball);
  Game_state.init ball player1 player2;
  false

(* *)

let chain_functions f_list =
  let funs = ref f_list in
  fun dt -> match !funs with
    | [] -> false
    | f :: ll -> 
        if f dt then true
        else begin
          funs := ll;
          true
        end

let play_game dt =
  (* Update all systems *)
  System.update_all dt;
  (* One player reach 10 points *)
  Game_state.get_score1 () < 10 && Game_state.get_score2 () < 10
  
let end_game _dt = false

let f_lists = [load_graphics; init_game; play_game; end_game]

let update_loop () = 
  Gfx.main_loop (chain_functions f_lists)

let () =
  update_loop ()
