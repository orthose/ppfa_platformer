open Ecs

(* Forme du joueur déterminée par les bonus 
Détermine sa vie et ses capacités *)
type form_player = Small | Big | Fire

type t = {
  player : Entity.t;
  mutable score : int;
  mutable life : int;
  mutable game_is_won : bool;
  (* Moment où le joueur est touché par un ennemi *)
  mutable dt_hit : float;
  mutable  form : form_player;
}

let init_game_state = {
  player = Entity.dummy;
  score = 0;
  life = Globals.life_player;
  game_is_won = false;
  dt_hit = 0.0;
  form = Big;
}

let state = ref init_game_state

let get_player () = !state.player
let get_score () = !state.score
let get_life () = !state.life
let get_game_is_won () = !state.game_is_won
let get_dt_hit () = !state.dt_hit
let get_form () = !state.form

let incr_score () = 
  !state.score <- !state.score + 1
  
let incr_life () =
  !state.life <- !state.life + 1
  
let decr_life () =
  !state.life <- !state.life - 1
  
let set_dt_hit dt = 
  !state.dt_hit <- dt
  
let set_form form =
  !state.form <- form
  
let game_is_won () =
  !state.game_is_won <- true
  
let init e =
  state := {!state with player = e}
  
let reset_life () =
  !state.life <- Globals.life_player
  
let reset () =
  state := init_game_state
