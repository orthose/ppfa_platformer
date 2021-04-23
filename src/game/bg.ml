open Component_defs
open System_defs
open Ecs

let create img =
  let e = Entity.create () in
  
  (* Pavage du background sur toute la longueur du niveau *)
  Position.set e (MultiPoint 
    (List.init (
      (int_of_float 
        (ceil 
          (!Level.width_max /. float_of_int Globals.canvas_width)
        )
      )
      ) (fun i ->
          Vector.{
            x = (float_of_int i) *. (float_of_int Globals.canvas_width); 
            y = 0.0}
        )
      )
    );
  Box.set e {width = Globals.canvas_width; 
    height = Globals.canvas_height};
  Surface.set e (
    Texture.create_image img 
    Globals.canvas_width
    Globals.canvas_height
  );
    
  Draw_S.register e;
  e