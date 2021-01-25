open Component_defs

type state =
  Playing | Player1Lost | Player2Lost

let state = ref Player1Lost
let init () = ()

let random_dir tmin tmax n =
  let t = tmin +. Random.float (tmax -. tmin) in
  let x = n *. cos t in
  let y = n *. sin t in
  Vector.{ x = x; y = y}

let pi = 2. *. asin 1.0

let update _dt el =
  (* Check for keyboard events *)
  let rec loop_events () =
    let open Player_control in
    match Gfx.poll_event () with

     NoEvent -> ()
    | KeyUp _ -> loop_events ()
    | KeyDown key ->
      List.iter (fun e ->
        match List.assoc key (PC.get e), !state with
        Move_Up, Playing ->
          let pos = Position.get e in
          Position.set e { pos with y = pos.y -. 10.0 }
      | Move_Down, Playing ->
        let pos = Position.get e in
        Position.set e { pos with y = pos.y +. 10.0 }
      | Launch, Player1Lost ->
        state := Playing;
        Position.set e { x = 70.0; y = 290.0 };
        Velocity.set e (random_dir  (-.pi/.3.0) (pi/.3.0) 3.0)
      | Launch, Player2Lost ->
        state := Playing;
        Position.set e { x = 690.0; y = 290.0 };
        Velocity.set e (random_dir  (2. *. pi/.3.0) (4. *. pi/.3.0) 3.0)
      | _ -> ()
      | exception Not_found -> ()

        ) el;
        loop_events ()
      in
        loop_events ()
