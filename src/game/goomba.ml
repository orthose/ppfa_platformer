open Component_defs

let create =
  let move (init_pos:Vector.t) e () =
    let pos = 
      match Position.get e with
      | Point(p) -> p
      | _ -> failwith "Enemy has only Point position"
    in
    let v = Velocity.get e in
    let dir =
      (* si on va vers la droite *)
      if v.x > 0.0 then
        (* On repart à gauche *)
        if pos.x > init_pos.x +. 100. then -1.0
        else 1.0
      (* On va vers la gauche *)
      else
        (* On repart à droite *)
        if pos.x < init_pos.x -. 100. then 1.0
        else -1.0
    in
    let f = SumForces.get e in
    let new_f = Vector.add f { x = 0.02 *. dir; y = 0.0 } in
    SumForces.set e new_f
  in
  let box = Rect.{
    width = Globals.unit_box.width / 2; 
    height = Globals.unit_box.height / 2 } 
  in 
  Abstract_enemy.create
  "goomba" Goomba Vector.zero
  box (Texture.gray) 10. 10 true move 