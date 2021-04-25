open Component_defs

let init () = ()

let time = ref 0.0
let update dt el =
  let delta_t = dt -. !time in
  time := dt;
  List.iter (fun e ->
    let pos = 
      match Position.get e with
      | Point pos -> pos
      | _ -> failwith "Cannot move a list of positions"
    in
    let speed = Vector.mult delta_t (Velocity.get e) in
    if not (Vector.is_zero speed) then
      (* On évite de mettre à jour les objets qui ne bougent pas *)
      Position.set e (Point (Vector.add pos speed))
    ) el
