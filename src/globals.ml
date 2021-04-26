(* Définitions globales, qu'on suppose constantes *)
let canvas_width = 800
let canvas_height = 600

(* Unité d'échantillonnage de la matrice de niveau *)
let unit_box = Rect.{width = 32; height = 32}
let player_box = Rect.{width = 32; height = 64}

(* Constantes du moteur physique *)
let gravity = Vector.{ x = 0.0; y = 0.00095 }
let friction = -0.20
let jump = Vector.{ x = 0.0; y = -0.19 }
let left = Vector.{ x = -0.10 ; y = 0.0 }
let right = Vector.{ x = 0.10 ; y = 0.0 }
let down = Vector.{ x= 0.0; y = 0.02 }
let activate_max_velocity = false
let max_velocity = 1.0

(* Scrolling vertical *)
let y_scroll = false

(* Temps d'invincibilité *)
let immortal_time_player = 3000.
let immortal_time_goomba = 1000.

(* Distances parcourues par les IA *)
let distance_goomba = 200.
let distance_boo = 100.
let distance_fire = 300.

(* Durée de vie des objets *)
let life_player = 5
let life_goomba = 3
let life_boo = 100 (* Boo est immortel *)
let lifespan_mushroom = 5000.
let lifespan_fire = 3000.

(* Vitesse des sprites *)
let rate_player = 25.
let rate_goomba = 50.
let rate_boo = 100.
let rate_coin = 25.
let rate_mystery = 100.
let rate_blink = 300.





