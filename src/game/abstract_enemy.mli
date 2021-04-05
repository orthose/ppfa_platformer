open Ecs

val create : 
  string -> Level.enemy
  -> Vector.t -> Rect.t -> Texture.t
  -> float -> int -> bool
  -> (Vector.t -> Entity.t -> unit -> unit) 
  -> Level.level -> Entity.t list