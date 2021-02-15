open Ecs

val create : string -> float -> float -> Entity.t
val reset : Entity.t -> float -> float -> unit

val move_up : Entity.t -> unit
val move_down : Entity.t -> unit
val stop : Entity.t -> unit