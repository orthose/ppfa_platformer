type t

val create : unit -> t
val pp : Format.formatter -> t -> unit
val hash : t -> int
val equal : t -> t -> bool
val compare : t -> t -> int

module Table : Hashtbl.S with type key = t
