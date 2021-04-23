open Ecs

val create : string -> Level.level -> Entity.t list

val unregister_systems : Entity.t -> unit