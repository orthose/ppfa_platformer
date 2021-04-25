open Ecs

val create : Level.level -> Entity.t list
val flatten : float -> Entity.t -> unit
val unregister_systems : Entity.t -> unit