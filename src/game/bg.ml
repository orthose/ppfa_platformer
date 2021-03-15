(*open Component_defs
open System_defs
open Ecs

let create i =
  let e = Entity.create () in
  
  Position.set e (Point {x = 0.; y = 0.});
  Box.set e {width = Globals.canvas_width; 
    height = Globals.canvas_height};
  Surface.set e (
    Texture.create_image i 
    Globals.canvas_width
    Globals.canvas_height
  );
    
  Draw_S.register e;
  e*)