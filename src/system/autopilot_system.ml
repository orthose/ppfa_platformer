open Component_defs

let init () = ()

let update _dt el =
  List.iter (fun e ->
    (Ai.get e) ()
    ) el