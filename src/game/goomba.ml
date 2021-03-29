let create =
  let box = Globals.unit_box in 
  Abstract_enemy.create
  "goomba" Goomba Vector.{x=0.5;y=0.}(*(Vector.random_x ())*)
  box (Texture.gray) 10. 10 true 