open Component_defs

(* Ce système est un peu particulier car il permet
d'éviter les fuites mémoire en enlevant dynamiquement
les entités des composants, notamment quand une entité
est tuée ou disparaît *)

let init () = ()

let update _dt el =
  List.iter (fun e ->
    (Remove.get e) ()
    ) el