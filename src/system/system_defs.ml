module Control_S = System.Make (Control_system)
module Draw_S = System.Make(Draw_system)
module Move_S = System.Make(Move_system)
module Logic_S = System.Make(Logic_system)

let () =
  System.register (module Draw_S);
  System.register (module Logic_S);
  System.register (module Move_S);
  System.register (module Control_S)
