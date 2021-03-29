open Ecs
open Level

(*let bg_img = Gfx.load_image "./images/clay.png"
let ball_img = Gfx.load_image "./images/ball_frames.png"*)

(*let load_graphics _dt = 
  not (Gfx.image_ready bg_img
    && Gfx.image_ready ball_img)*)
    
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

let test_level : Level.level = 
  Array.make_matrix 10 13 Empty
let () =
  for i = 0 to (13 - 1) do
    test_level.(10 - 2).(i) <- Ground;
    test_level.(10 - 1).(i) <- Ground
  done;
  test_level.(7).(2) <- Ground;
  test_level.(7).(12) <- Ground;
  test_level.(7).(5) <- Enemy Goomba
  
(*let test_level = Level_parser.parse "/static/files/level.txt"*)
  
let ground = Ground.create "ground" test_level

let player = Player.create "mario" 0. (64. *. 6.)

let goomba = Goomba.create test_level 

let init_game _dt = 

  Input_handler.register_command (KeyDown "z") (Player.jump);
  Input_handler.register_command (KeyUp "z") (Player.stop_jump);
  Input_handler.register_command (KeyDown "q") (Player.run_left);
  Input_handler.register_command (KeyUp "q") (Player.stop_run_left);
  Input_handler.register_command (KeyDown "d") (Player.run_right);
  Input_handler.register_command (KeyUp "d") (Player.stop_run_right);
  
  Random.self_init ();
  System.init_all ();
  Game_state.init player;
  false

let play_game dt =
  Player.do_move ();
  System.update_all dt;
  (* One player reach 10 points *)
  (*Game_state.get_score1 () < 10 && Game_state.get_score2 () < 10*)
  true
  
let end_game _dt = false

let f_lists = [(*load_graphics;*) init_game; play_game; end_game]

let update_loop () = 
  Gfx.main_loop (chain_functions f_lists)

let run () = update_loop ()
