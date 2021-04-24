open Ecs

type form_player = Small | Big | Fire

val get_player : unit -> Entity.t
val get_score : unit -> int
val get_life : unit -> int
val get_game_over : unit -> bool
val get_dt_hit : unit -> float
val get_form : unit -> form_player
val incr_score : unit -> unit
val incr_life : unit -> unit
val decr_life : unit -> unit
val set_dt_hit : float -> unit
val set_form : form_player -> unit
val init : Entity.t -> unit
val reset_life : unit -> unit