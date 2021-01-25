open Component_defs

let init () = ()

let update _dt el =
  List.iter (fun e ->
    let pos = Position.get e in
    let speed = Velocity.get e in
    Position.set e ({ x = pos.x +. speed.x; y = pos.y +. speed.y })
    ) el
