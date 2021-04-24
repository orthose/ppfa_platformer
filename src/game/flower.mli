open Ecs

val create : string -> Vector.t -> Entity.t

val unregister_systems : Entity.t -> unit