(* Définitions globales, qu'on suppose constantes *)
let canvas_width = 800
let canvas_height = 600

(* Unité d'échantillonnage de la matrice de niveau *)
let unit_box = Rect.{width = 64; height = 64}

let player_box = Rect.{width = 32; height = 64}

(* Constantes du moteur physique *)
let gravity = Vector.{ x = 0.0; y = 0.001 }
let friction = -0.20
let jump = Vector.{ x = 0.0; y = -0.20 }
let left = Vector.{ x = -0.10 ; y = 0.0 }
let right = Vector.{ x = 0.10 ; y = 0.0 }