open Vector

type t = { width : int; height : int }
let top_left v _b = v
let top_right v b = { v with x = v.x +. float b.width }
let bottom_left v b = { v with y = v.y +. float b.height }

let bottom_right v b = { x = v.x +. float b.width;
                         y = v.y +. float b.height;
                       }

let center v b = { 
  x = v.x +. 0.5 *. float b.width;
  y = v.y +. 0.5 *. float b.height;
}

let intersect v1 b1 v2 b2 =
  (* We use the Minkowski difference of Box1 and Box2 *)
  let x = v1.x -. v2.x -. float b2.width in
  let y = v1.y -. v2.y -. float b2.height in
  let h = float (b1.height + b2.height) in
  let w = float (b1.width + b2.width) in
  x < 0.0 && x +. w > 0.0 && y < 0.0 && y +. h > 0.0  

let pp fmt b = Format.fprintf fmt "[w:%d,h:%d]" b.width b.height
