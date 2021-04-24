open Component_defs

let create level =
  
  (* Fonction de déplacement automatique *)
  let move (init_pos:Vector.t) e () =
    let pos = 
      match Position.get e with
      | Point(p) -> p
      | _ -> failwith "Enemy has only Point position"
    in
    let v = Velocity.get e in
    let dir =
      (* Longueur de la distance parcourue par boo *)
      let size_walk = 100. in
      (* On descend *)
      if v.y >= 0.0 then
        (* On remonte *)
        if pos.y > init_pos.y +. size_walk then -1.0
        else 1.0
      (* On remonte *)
      else
        (* On descend *)
        if pos.y < init_pos.y -. size_walk then 1.0
        else -1.0
    in
    Velocity.set e { x = 0.0; y = 0.05 *. dir }
  in
  
  let box = Rect.{
    width = Globals.unit_box.width; 
    height = Globals.unit_box.height } 
  in 
  (* Appel de la fonction de création d'ennemi *)
  Abstract_enemy.create
  "boo" Boo Vector.zero
  box (Texture.create_animation
    (Graphics.get_image 
        "resources/images/boo.png")
    1 6
    32 32
    (Globals.unit_box.width)
    (Globals.unit_box.height) 100.
    ) 0.0 100 false move level