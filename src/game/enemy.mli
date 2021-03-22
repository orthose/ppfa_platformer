open Ecs

val create : string -> float -> float -> (Vector.t -> Vector.t) -> Entity.t
val do_move : unit -> unit