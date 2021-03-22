open Ecs

val create : string -> float -> float -> Entity.t

val do_move : unit -> unit
val jump : unit -> unit
val run_left : unit -> unit
val run_right : unit -> unit
val stop_jump : unit -> unit
val stop_run_left : unit -> unit
val stop_run_right : unit -> unit
