type turn = Playing | Player1Lost | Player2Lost
val init : Entity.t -> Entity.t -> Entity.t -> unit
val get_score1 : unit -> int
val get_score2 : unit -> int
val get_turn : unit -> turn
val play : unit -> unit
val player_score : Entity.t -> unit
val get_player1 : unit -> Entity.t
val get_player2 : unit -> Entity.t
val get_ball : unit -> Entity.t