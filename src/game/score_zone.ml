open Component_defs
open System_defs



let resolve_collision self other =
  if other == Game_state.get_ball () then begin
    let owner = Owner.get self in
    let p1 = Game_state.get_player1 () in
    let p2 = Game_state.get_player2 () in
    Game_state.player_score owner;
    Player.reset p1 Globals.player1_init_x Globals.player_init_y;
    Player.reset p2 Globals.player2_init_x Globals.player_init_y;
    let bx =
      if owner == p1 then
        Globals.ball_player2_init_x
      else
        Globals.ball_player1_init_x
    in
    Ball.reset other bx Globals.ball_init_y
  end

let create name player x y =
  let e = Entity.create () in
  (* components *)
  Position.set e { x = x; y = y};
  Velocity.set e Vector.zero;
  Mass.set e infinity;
  Box.set e {width = Globals.score_zone_width; height=Globals.score_zone_height };
  Name.set e name;
  Owner.set e player;
  CollisionResolver.set e resolve_collision;
  (* systems *)
  Collision_S.register e;
  e
