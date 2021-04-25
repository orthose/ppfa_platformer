open Ecs

val create : string -> Vector.t -> bool -> Entity.t

val unregister_systems : Entity.t -> unit