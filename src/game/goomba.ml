open Component_defs

let remove e =
  Abstract_enemy.remove e true
  
let create level =

  (* Création des sprites de goomba *)
  let sprite_left =
    Texture.create_animation
      (Graphics.get_image 
        "resources/images/goomba-left.png")
      8 2
      121 99
      Globals.unit_box.width
      Globals.unit_box.height
      Globals.rate_goomba
  in
  let sprite_right =
    Texture.create_animation
      (Graphics.get_image 
        "resources/images/goomba-right.png")
      8 2
      121 99
      Globals.unit_box.width
      Globals.unit_box.height
      Globals.rate_goomba
  in
  
  (* Fonction de déplacement automatique *)
  let move (init_pos:Vector.t) e dt =
    (* Temps auquel a été touché goomba et vie *)
    let (dt_hit, life) =
      match ElementGrid.get e with
      | Enemy (Goomba (dt_hit, life)) -> dt_hit, life
      | _ -> failwith "Goomba is not a goomba"
    in
    (* Temps d'invincibilité de Goomba *)
    if dt -. dt_hit >= Globals.immortal_time_goomba then
      (* Goomba est mort *)
      if life <= 0 then
        remove e
      (* Goomba avance *)
      else
      let pos = 
        match Position.get e with
        | Point(p) -> p
        | _ -> failwith "Goomba has only Point position"
      in
      let v = 
        match Velocity.get e with
        | Physical v -> v
        | _ -> failwith "Goomba has only Physical velocity"
      in
      let dir =
        (* Longueur de la distance parcourue par goomba *)
        let distance = Globals.distance_goomba in
        (* On va vers la droite *)
        if v.x >= 0.0 then
          (* On repart à gauche *)
          if pos.x > init_pos.x +. distance then 
            let () = Surface.set e sprite_left in
            -1.0
          else 1.0
        (* On va vers la gauche *)
        else
          (* On repart à droite *)
          if pos.x < init_pos.x -. distance then 
            let () = Surface.set e sprite_right in
            1.0
          else -1.0
      in
      let f = SumForces.get e in
      let new_f = Vector.add f { x = 0.02 *. dir; y = -.0.0 } in
      SumForces.set e new_f
  in
  
  let box = Rect.{
    width = Globals.unit_box.width; 
    height = Globals.unit_box.height } 
  in 
  (* Appel de la fonction de création d'ennemi *)
  Abstract_enemy.create
  "goomba" (Goomba (0.0, (Globals.life_goomba))) Vector.zero
  box sprite_right 10.0 true move level
  
let flatten dt e =
  let sprite_flatten_left = 
    Texture.create_image
      (Graphics.get_image 
        "resources/images/goomba-flatten-left.png")
      Globals.unit_box.width
      Globals.unit_box.height
  in
  let sprite_flatten_right = 
    Texture.create_image
      (Graphics.get_image 
        "resources/images/goomba-flatten-right.png")
      Globals.unit_box.width
      Globals.unit_box.height
  in
  let life =
    match ElementGrid.get e with
    | Enemy (Goomba (_, life)) -> life
    | _ -> failwith "Goomba is not a goomba"
  in
  ElementGrid.set e (Enemy (Goomba (dt, (life - 1)) ) );
  let v = 
    match Velocity.get e with 
    | Physical v -> v
    | _ -> failwith "Goomba has only Physical velocity"
  in
  if v.x >= 0.0 then
    Surface.set e sprite_flatten_right
  else 
    Surface.set e sprite_flatten_left
    