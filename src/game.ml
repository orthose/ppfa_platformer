open Ecs
open Level  
  
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
      
(* Chargement des textures *)
(* ATTENTION: Ne pas mettre dans init_game *)
let () =
  let lsprites = [
    "goomba-left.png";
    "goomba-right.png";
    "ground.png";
    "ice.png";
    "mushroom.png";
    "spike.png";
    "coin.png";
    "bg-hill.png"
    ] in
  let path = "resources/images/" in
  Array.iter (fun s ->
    let sprite_player = path^(s.Player.sprite) in
    Graphics.load_image sprite_player
    ) Player.sprites;
  List.iter (fun s -> 
    Graphics.load_image (path^s);
    ) lsprites
  
(* ATTENTION: Ordre d'impression inversé *)
let init_game _dt = 

  (* Chargement du niveau *)
  let level = Level_parser.parse "/static/files/level1.txt" in
  
  (* Création des plateformes *)
  let _ground = Ground.create "ground" level in
  let _ice = Ice.create "ice" level in
  let _mushroom = Mushroom.create "mushroom" level in
  let _coin = Coin.create "coin" level in
  let spike = Spike.create "spike" level in
  
  (* Création des ennemis *)
  let _goomba = Goomba.create level in
  
  (* Création du joueur *)
  let player = Player.create "mario" 0. (64. *. 6.) spike in
  Game_state.init player;
  Player.set_sprite 0;
  
  (* Création du background *)
  let _bg = Bg.create (Graphics.get_image 
    "resources/images/bg-hill.png") in
  
  (* Contrôles du joueur *)
  Input_handler.register_command (KeyDown "z") (Player.jump);
  Input_handler.register_command (KeyUp "z") (Player.stop_jump);
  Input_handler.register_command (KeyDown "q") (Player.run_left);
  Input_handler.register_command (KeyUp "q") (Player.stop_run_left);
  Input_handler.register_command (KeyDown "d") (Player.run_right);
  Input_handler.register_command (KeyUp "d") (Player.stop_run_right);
  
  Random.self_init ();
  System.init_all ();
  false

let play_game dt =
  Player.do_move ();
  System.update_all dt;
  (* TODO: Si le joueur meurt renvoyer false,
  si le joueur a gagné afficher un joli message *)
  true
  
let end_game _dt =
  (* TODO: Recommencer le niveau en supprimant 
  toutes les entités actuelles, et en vidant 
  composants et systèmes *) 
  false

let f_lists = [Graphics.still_loading; init_game; play_game; end_game]

let update_loop () = 
  Gfx.main_loop (chain_functions f_lists)

let run () = update_loop ()
