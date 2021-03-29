open Ecs

val create : 
  string -> Level.enemy
  -> Vector.t -> Rect.t -> Texture.t
  -> float -> int -> bool 
  -> Level.level -> Entity.t list