open Ecs

type t = {
  player : Entity.t;
  mutable score : int;
  mutable life : int;
  mutable game_over : bool;
  (* Moment où le joueur est touché par un ennemi *)
  mutable dt_hit : float;
}

let state = ref {
  player = Entity.dummy;
  score = 0;
  life = 10;
  game_over = false;
  dt_hit = 0.0;
}

let get_player () = !state.player
let get_score () = !state.score
let get_life () = !state.life
let get_game_over () = !state.game_over
let get_dt_hit () = !state.dt_hit

let incr_score () = 
  !state.score <- !state.score + 1
  
let incr_life () =
  !state.life <- !state.life + 1
  
let decr_life () =
  !state.life <- !state.life - 1
  
let set_dt_hit dt = 
  !state.dt_hit <- dt
  
let init e =
  state := {!state with player = e}
