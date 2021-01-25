open Component_defs
open Control_system

let init () = ()

let update _dt el =
      let check_collisions () =
        let el = List.sort
        (fun e1 e2 -> compare (Name.get e1) (Name.get e2)) el
       in
        List.iter (fun e1 ->
          List.iter (fun e2 ->
            let n1 = Name.get e1 in
            let n2 = Name.get e2 in
            if n2 > n1 then begin
              let pos1 = Position.get e1 in
              let box1 = Box.get e1 in
              let pos2 = Position.get e2 in
              let box2 = Box.get e2 in
              if Rect.intersect pos1 box1 pos2 box2 then
                match n1, n2 with
                "ball", ("player1"|"player2") ->
                  let v = Velocity.get e1 in
                  Velocity.set e1 { v with x = -.v.x };
                  let (s, p) = Score.get e2 in
                  Score.set e2 ((s + 1), p)
              | "ball", ("wall_top"|"wall_bottom") ->
                let v = Velocity.get e1 in
                Velocity.set e1 { v with y = -.v.y }
              |  "ball", "wall_left" ->
                  Velocity.set e1 {x = 0.0; y = 0.0 };
                  Control_system.state := Player1Lost
              |  "ball", "wall_right" ->
                Velocity.set e1 {x = 0.0; y = 0.0 };
                Control_system.state := Player2Lost
              |  ("player1"|"player2"), "wall_top" ->
                Position.set e1 { pos1 with y = 20.0 }
              |  ("player1"|"player2"), "wall_bottom" ->
                Position.set e1 { pos1 with y = 500.0 }
              | _ -> ()

            end
            ) el ) el
          in
        check_collisions ()
