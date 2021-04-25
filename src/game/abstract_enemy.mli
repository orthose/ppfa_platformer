open Ecs

val create : 
  string -> Level.enemy
  -> Vector.t -> Rect.t -> Texture.t
  -> float -> int -> bool
  -> (Vector.t -> Entity.t -> float -> unit) 
  -> Level.level -> Entity.t list
  
val remove : Entity.t -> bool -> unit