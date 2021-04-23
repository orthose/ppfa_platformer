open Ecs

type player_sprite = {
  sprite : string;
  num_w : int;
  num_h : int;
  sw : int;
  sh : int
}

val create : string -> float -> float -> Entity.t ->Entity.t

val sprites : player_sprite array
val set_sprite : int -> unit
val do_move : unit -> unit
val jump : unit -> unit
val run_left : unit -> unit
val run_right : unit -> unit
val stop_jump : unit -> unit
val stop_run_left : unit -> unit
val stop_run_right : unit -> unit
