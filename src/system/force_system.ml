open Component_defs
open Ecs

let init () = ()

let last_dt = ref 0.0
let update dt el =
  (* Combien de temps depuis la dernière update ? *)
  let delta = min (dt -. !last_dt) 16.6 in
  last_dt := dt;
  
  (* Gravité attraction vers le bas *)
  let g = Globals.gravity in
  List.iter (fun e ->
    (*
      Somme des forces = masse * accéleration
      vitesse = accéleration * temps
      vitesse = forces/masse * temps
    *)
    let old_v = Velocity.get e in
    let mass = Mass.get e in
    let forces = SumForces.get e in
    let forces = Vector.add forces (Vector.mult mass g) in (* on ajoute la gravité *)
    let forces =
        (* on ajoute les frottements du support *)
        let platform = Resting.get e in
        let friction =
          if platform = Entity.dummy then Globals.friction
          else Friction.get platform
        in
        let f = Vector.mult (mass /. delta) { x= old_v.x *. friction ; y = 0.0 } in
        Vector.add f forces
    in
    let new_v = Vector.add old_v (Vector.mult (delta/. mass) forces) in
    Velocity.set e new_v;
    SumForces.set e Vector.zero;
    ) el
