type action =
    Launch
  | Move_Up
  | Move_Down

type t = (string * action) list
