type turn = Playing
  | Player1Lost
  | Player2Lost

type t = {

  ball : Entity.t;
  player1 : Entity.t;
  player2 : Entity.t;
  mutable score1 : int;
  mutable score2 : int;
  mutable turn : turn;
}

let state = ref {
  ball = Entity.dummy;
  player1 = Entity.dummy;
  player2 = Entity.dummy;
  score1 = 0;
  score2 = 0;
  turn = Player1Lost
}

let get_ball () = !state.ball
let get_player1 () = !state.player1
let get_player2 () = !state.player2
let get_score1 () = !state.score1
let get_score2 () = !state.score2

let get_turn () = !state.turn

let play () = !state.turn <- Playing
let player_score e =
  if e == !state.player1 then begin
    !state.score1 <- !state.score1 + 1;
    !state.turn <- Player2Lost
  end else if e == !state.player2 then begin
    !state.score1 <- !state.score2 + 1;
    !state.turn <- Player1Lost
  end else
    failwith (Format.asprintf "Invalid player Entity %a" Entity.pp e)


let init be pe1 pe2 =
  state := { !state with ball = be; player1 = pe1; player2 = pe2 }
