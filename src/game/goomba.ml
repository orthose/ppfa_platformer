open Component_defs

let create level =

  (* Création des sprites de goomba *)
  let sprite_left =
    Texture.create_animation
      (Graphics.get_image 
        "resources/images/goomba-left.png")
      8 2
      121 99
      (Globals.unit_box.width)
      (Globals.unit_box.height) 50.
  in
let sprite_right =
  Texture.create_animation
    (Graphics.get_image 
      "resources/images/goomba-right.png")
    8 2
    121 99
    (Globals.unit_box.width)
    (Globals.unit_box.height) 50. 
  in
  
  (* Fonction de déplacement automatique *)
  let move (init_pos:Vector.t) e _dt =
    let pos = 
      match Position.get e with
      | Point(p) -> p
      | _ -> failwith "Enemy has only Point position"
    in
    let v = Velocity.get e in
    let dir =
      (* Longueur de la distance parcourue par goomba *)
      let size_walk = 200. in
      (* On va vers la droite *)
      if v.x >= 0.0 then
        (* On repart à gauche *)
        if pos.x > init_pos.x +. size_walk then 
          let () = Surface.set e sprite_left in
          -1.0
        else 1.0
      (* On va vers la gauche *)
      else
        (* On repart à droite *)
        if pos.x < init_pos.x -. size_walk then 
          let () = Surface.set e sprite_right in
          1.0
        else -1.0
    in
    let f = SumForces.get e in
    let new_f = Vector.add f { x = 0.02 *. dir; y = 0.0 } in
    SumForces.set e new_f
  in
  
  let box = Rect.{
    width = Globals.unit_box.width; 
    height = Globals.unit_box.height } 
  in 
  (* Appel de la fonction de création d'ennemi *)
  Abstract_enemy.create
  "goomba" Goomba Vector.zero
  box sprite_right 10. 10 true move level