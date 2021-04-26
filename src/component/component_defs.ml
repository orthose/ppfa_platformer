open Ecs

module Point = struct 
  type t = Point of Vector.t | MultiPoint of Vector.t list end
module Position = Component.Make(struct include Point let name = "position" end)
module Speed = struct
  type t = Physical of Vector.t | Animation of Vector.t end
module Velocity = struct include Component.Make(struct include Speed let name = "velocity" end)
 let set = 
  if Globals.activate_max_velocity then
    fun e v ->
      let v' = match v with Speed.Physical a -> a | Speed.Animation a -> a in 
      if Vector.norm v' <= Globals.max_velocity then set e v else ()
  else set end
module Mass = Component.Make (struct type t = float let name = "mass" end)
module Box = Component.Make(struct include Rect let name = "box" end)
module Surface = Component.Make (struct include Texture let name = "texture" end)
module Name = Component.Make(struct type t = string let name = "name" end)
module CollisionResolver = Component.Make(struct type t = float -> Side.t -> Entity.t -> Entity.t -> unit let name = "resolver" end)
module ElementGrid = Component.Make(struct include Level let name="element_grid" end)
module Resting = Component.Make(struct type t = Entity.t let name = "nobounce" end)
module SumForces = Component.Make(struct type t = Vector.t let name = "forces" end)
module Friction = Component.Make(struct type t = float let name = "friction" end)
module Elasticity = Component.Make(struct type t = float let name = "elasticity" end)
module Life = Component.Make(struct type t = int let name = "life" end)
module Ai = Component.Make(struct type t = float -> unit let name = "ai" end)
module Remove =  Component.Make(struct type t = unit -> unit let name = "remove" end)

let reset_all () =
  Position.reset ();
  Velocity.reset ();
  Mass.reset ();
  Box.reset ();
  Surface.reset ();
  Name.reset ();
  CollisionResolver.reset ();
  ElementGrid.reset ();
  Resting.reset ();
  SumForces.reset ();
  Friction.reset ();
  Elasticity.reset ();
  Life.reset ();
  Ai.reset ();
  Remove.reset ()
  
  