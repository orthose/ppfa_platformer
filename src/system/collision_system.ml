open Component_defs
open Ecs

let init () = ()

(* les composants du rectangle r1 et r2 sont pos1 box1 pos2 box2 *)
(* e1 = entité déplaçable player ou ennemy *)
(* e2 = plateforme statique avec elastacité *)
let compute_collision dt e1 e2 pos1 pos2 =
  (* les box *)
  let box1 = Box.get e1 in
  let box2 = Box.get e2 in
  (* les vitesses *)
  let v1 = Velocity.get e1 in
  let v2 = Velocity.get e2 in
  (* [1] la soustraction de Minkowski *)
  let s_pos, s_rect = Rect.mdiff pos2 box2 pos1 box1 in
  (* [2] si intersection et un des objets est mobile, les objets rebondissent *)
  if Rect.has_origin s_pos s_rect &&
    not (Vector.is_zero v1 && Vector.is_zero v2)
  then begin
    (* La friction de la plateforme est transmise au joueur *)
    Friction.set e1 (Friction.get e2);
    (* [3] le plus petit des vecteurs a b c d *)
    let a = Vector.{ x = s_pos.x; y = 0.0} in
    let b = Vector.{ x = float s_rect.width +. s_pos.x; y = 0.0 } in
    let c = Vector.{ x = 0.0; y = s_pos.y } in
    let d = Vector.{ x = 0.0; y = float s_rect.height +. s_pos.y} in 
    let n = List.fold_left (fun min_v v ->
      if Vector.norm v  < Vector.norm min_v then v else min_v) 
      a [ b; c ; d]
    in
    
    (*  [4] rapport des vitesses et déplacement des objets *)
    let n_v1 = Vector.norm v1 in
    let n_v2 = Vector.norm v2 in
    let s = (n_v1 +. n_v2) in
    let n1 = n_v1 /. s in
    let n2 = n_v2 /. s in
    let delta_pos1 = Vector.mult n1 n in
    let _delta_pos2 = Vector.mult (Float.neg n2) n in
    Position.set e1 (Point (Vector.add pos1 delta_pos1));
    (* Simplification: Inutile l'entité e2 est statique *)
    (*Position.set e2 (Vector.add pos2 delta_pos2);*)
    if Resting.has_component e1 then Resting.set e1 (
      if n = c then e2 else Entity.dummy
      );
    (* Simplification: Inutile car e2 n'est pas censée avoir de resting *)
    (*if Resting.has_component e2 then Resting.set e2 (n == c);*)
  
    (* [5] On normalise n (on calcule un vecteur de même direction mais de norme 1) *)
    let n = Vector.normalize n in
    (* [6] Vitesse relative entre v2 et v1 *)
    let v = Vector.sub v1 v2 in
  
    (* Préparation au calcul de l'impulsion *)
    (* Elasticité fixe. En pratique, l'elasticité peut être stockée dans
    les objets comme un composant : 1 pour la balle et les murs, 0.5 pour
    des obstacles absorbants, 1.2 pour des obstacles rebondissant, … *)
    let e = Elasticity.get e2 in
  
    (* normalisation des masses *)
    let m1 = Mass.get e1 in
    let m2 = Mass.get e2 in    
    let m1, m2 = 
      if Float.is_infinite m1 && Float.is_infinite m2 then
        if n_v1 = 0.0 then m1, 1.0 else if n_v2 = 0.0 then 1.0, m2 
        else 0.0, 0.0
      else m1, m2
    in
    (* [7] calcul de l'impulsion *)
    let j =
      (-.(1.0 +. e) *. Vector.dot v n)/. ( (1. /. m1) +. (1. /. m2))
    in
    (* [8] calcul des nouvelles vitesses *)
    let new_v1 = Vector.add v1 (Vector.mult (j/. m1) n) in
    (* Simplification: Inutile car e2 est censée rester immobile *)
    (*let new_v2 = Vector.sub v2 (Vector.mult (j/. m2) n) in*)
    (* [9] mise à jour des vitesses *)
    Velocity.set e1 new_v1;
    (* Simplification: Inutile car e2 est censée rester immobile *)
    (*Velocity.set e2 new_v2;*)
    (* [10] appel des resolveurs *)
    if CollisionResolver.has_component e1 then (CollisionResolver.get e1) dt e1 e2;
    (*if CollisionResolver.has_component e2 then (CollisionResolver.get e2) e2 e1*)
  end

let update dt el =
  List.iter (fun e1 ->
    List.iter (fun e2 ->
      (* Une double boucle qui évite de comparer deux fois
         les objets : si on compare A et B, on ne compare pas B et A.
         Il faudra améliorer cela si on a beaucoup (> 30) objets simultanément.
      *)
      if e1 <> e2 then
        
        (* Entité simple joueur ou ennemi *)
        let pos1 =
          match Position.get e1 with
          | Point pos -> pos
          | _ -> failwith "Basic entity has only simple position"
        in
        
        (* Le système de collision doit faire la différence
        entre une box simple et une liste de box issue du
        parser de niveau *)
        match Position.get e2 with
        | Point pos2 ->
            compute_collision dt
            e1 e2
            pos1 pos2
        | MultiPoint lpos ->
            (* TODO: Améliorer en ne regardant que les objets proches 
            de e1 et dans l'écran *)
            List.iter (fun pos2 ->
              compute_collision dt
              e1 e2
              pos1 pos2
              ) lpos
    ) el) (
      (Game_state.get_player ()) 
      :: (List.filter_map (fun (e, v) -> 
            match v with
            | Level.Enemy _ -> Some e
            | _ -> None
            ) (ElementGrid.members ()))
      )
