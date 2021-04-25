open Ecs

module Control_S = System.Make (Control_system)
module Draw_S = System.Make(Draw_system)
module Move_S = System.Make(Move_system)
module Collision_S = System.Make(Collision_system)
module Force_S = System.Make(Force_system)
module Autopilot_S = System.Make(Autopilot_system)
module Remove_S = System.Make(Remove_system)

let () =
  (* Toujours laisser Remove_S en premier pour
  qu'il soit update en dernier  *)
  System.register (module Remove_S);
  System.register (module Draw_S);
  System.register (module Move_S);
  System.register (module Control_S);
  System.register (module Force_S);
  System.register (module Collision_S);
  System.register (module Autopilot_S)
