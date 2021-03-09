(* Définitions globales, qu'on suppose constantes *)
let canvas_width = 800
let canvas_height = 600

(* Unité d'échantillonnage de la matrice de niveau *)
let unit_width = (canvas_width * 10) / 100
let unit_height = unit_width
let unit_box = Rect.{width = unit_width; height = unit_height}

let ball_size = 20
let wall_thickness = 20

let score_zone_width = 40
let score_zone_height = canvas_height - 2* wall_thickness

let paddle_width = 20
let paddle_height = 80

let player_init_y = float (canvas_height / 2 - paddle_height / 2)

let player1_init_x = float score_zone_width
let player2_init_x = float (canvas_width - score_zone_width - paddle_width)
let ball_init_y = float (canvas_height / 2 - ball_size / 2)
let ball_player1_init_x = player1_init_x +. float (paddle_width) +. 10.0
let ball_player2_init_x = player2_init_x -. 10.0 -. float ball_size