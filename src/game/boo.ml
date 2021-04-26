open Component_defs

let create level =
  
  (* Fonction de déplacement automatique *)
  let move (init_pos:Vector.t) e _dt =
    let pos = 
      match Position.get e with
      | Point(p) -> p
      | _ -> failwith "Boo has only Point position"
    in
    let v = 
      match Velocity.get e with
      | Physical v -> v
      | _ -> failwith "Boo has only Physical velocity" 
    in
    let dir =
      (* Longueur de la distance parcourue par boo *)
      let distance = Globals.distance_boo in
      (* On descend *)
      if v.y >= 0.0 then
        (* On remonte *)
        if pos.y > init_pos.y +. distance then -1.0
        else 1.0
      (* On remonte *)
      else
        (* On descend *)
        if pos.y < init_pos.y -. distance then 1.0
        else -1.0
    in
    Velocity.set e (Physical { x = 0.0; y = 0.05 *. dir })
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
    Globals.unit_box.width
    Globals.unit_box.height
    Globals.rate_boo
    ) 0.0 (Globals.life_boo) false move level