open Component_defs

let init () = ()

let update dt el =
  List.iter (fun e ->
    (Ai.get e) dt
    ) el