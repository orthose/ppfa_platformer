open Ecs

val create : Level.level -> Entity.t list
val flatten : float -> Entity.t -> unit
val remove : Entity.t -> unit