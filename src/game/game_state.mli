open Ecs

val get_player : unit -> Entity.t
val get_score : unit -> int
val get_life : unit -> int
val get_game_over : unit -> bool
val incr_score : unit -> unit
val incr_life : unit -> unit
val decr_life : unit -> unit
val init : Entity.t -> unit