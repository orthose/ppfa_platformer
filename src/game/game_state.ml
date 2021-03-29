open Ecs

type t = {
  player : Entity.t;
  mutable score : int;
  mutable life : int;
  mutable game_over : bool
}

let state = ref {
  player = Entity.dummy;
  score = 0;
  life = 10;
  game_over = false
}

let get_player () = !state.player
let get_score () = !state.score
let get_life () = !state.life
let get_game_over () = !state.game_over

let incr_score () = 
  !state.score <- !state.score + 1
  
let incr_life () =
  !state.life <- !state.life + 1
  
let decr_life () =
  !state.life <- !state.life - 1
  
let init e =
  state := {!state with player = e}
