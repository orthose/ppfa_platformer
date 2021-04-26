open Ecs
open Level  
  
let chain_functions f_list =
  let funs = ref f_list in
  fun dt -> match !funs with
  (* On recommence en boucle *)
  | [] -> funs := f_list; true
  (* On consomme au fur et à mesure la liste *)
  | f :: ll -> 
      if f dt then true
      else begin
        funs := ll;
        true
      end
      
(* Ensemble des niveaux (fichier, background) *)
let current_level = ref 0
let levels = [|
  ("level1.txt", "bg-hill.png");
  ("level2.txt", "bg-hill-cloud.png");
|]

let next_level () =
  current_level := (!current_level + 1) mod (Array.length levels)
      
(* Chargement des textures *)
(* ATTENTION: Ne pas mettre dans init_game *)
let () =
  let lsprites = [
    "goomba-left.png"; "goomba-right.png";
    "goomba-flatten-left.png"; "goomba-flatten-right.png"; 
    "boo.png";
    "ground.png"; "ice.png"; "toadstool.png"; "spike.png";
    "sand.png"; "mystery.png"; "mystery-disabled.png"; 
    "mushroom.png"; "flower.png"; "coin.png"; 
    "switch.png"; "switch-disabled.png";
    "fire-right.png"; "fire-left.png";
    ] in
  let path = "resources/images/" in
  Array.iter (fun s ->
    let sprite_player = path^(s.Player.sprite) in
    Graphics.load_image sprite_player
    ) Player.sprites;
  Array.iter (fun (_, s) ->
    let sprite_bg = path^s in
    Graphics.load_image sprite_bg
    ) levels;
  List.iter (fun s -> 
    Graphics.load_image (path^s);
    ) lsprites
  
(* ATTENTION: Ordre d'impression inversé *)
let init_game _dt = 

  (* Chargement du niveau *)
  let (level_file, background) = levels.(!current_level) in
  let level = Level_parser.parse ("/static/files/"^level_file) in
  
  (* Création des plateformes *)
  let _ground = Ground.create "ground" level in
  let _ice = Ice.create "ice" level in
  let _toadstool = Toadstool.create "toadstool" level in
  let _sand = Sand.create "sand" level in
  let _spike = Spike.create "spike" level in
  let _coin = Coin.create "coin" level in
  let _mystery = Mystery.create "mystery" level in
  let _switch = Switch.create "switch" level in
  
  (* Création des ennemis *)
  let _goomba = Goomba.create level in
  let _boo = Boo.create level in
  
  (* Création du joueur *)
  let player = Player.create "mario" 0. (
    (float)Globals.unit_box.height *. 15.) in
  Game_state.init player;
  Player.set_sprite 0;
  
  (* Création du background *)
  let _bg = Bg.create (Graphics.get_image
    ("resources/images/"^background)) in
  
  (* Contrôles du joueur *)
  Input_handler.register_command (KeyDown "z") (Player.jump);
  Input_handler.register_command (KeyUp "z") (Player.stop_jump);
  Input_handler.register_command (KeyDown "q") (Player.run_left);
  Input_handler.register_command (KeyUp "q") (Player.stop_run_left);
  Input_handler.register_command (KeyDown "s") (Player.fall);
  Input_handler.register_command (KeyUp "s") (Player.stop_fall);
  Input_handler.register_command (KeyDown "d") (Player.run_right);
  Input_handler.register_command (KeyUp "d") (Player.stop_run_right);
  Input_handler.register_command (KeyDown "p") (Player.fire);
  
  Random.self_init ();
  System.init_all ();
  false

let play_game dt =
  Player.do_move ();
  System.update_all dt;
  (* Fin du jeu quand le joueur n'a plus de vie *)
  if Game_state.get_life () <= 0 then
    (* Note: On recommence le niveau actuel *)
    false
  (* On passe au niveau suivant *)
  else if Game_state.get_game_is_won () then
    (next_level (); false)
  (* Le niveau est en cours *)
  else true
  
let end_game _dt =
  (* Recommencer le niveau en supprimant 
  toutes les entités actuelles, et en vidant 
  composants et systèmes *)
  System.reset_all ();
  Draw_system.reset ();
  Component_defs.reset_all ();
  let form = Game_state.get_form () in
  Game_state.reset ();
  Game_state.set_form form;
  false

let f_lists = [Graphics.still_loading; init_game; play_game; end_game]

let update_loop () = 
  Gfx.main_loop (chain_functions f_lists)

let run () = update_loop ()
