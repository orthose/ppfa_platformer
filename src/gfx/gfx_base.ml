(* Exception raised when a graphical error occurs *)
exception GfxError of string

(* Type of user input events *)
type event =
  NoEvent          (* no event *)
| KeyUp of string  (* Key with a given name was released *)
| KeyDown of string (* Key with a given name was pressed *)



module type S =
sig
  type window  (* type of windows, not used at the moment *)
  type render  (* type of drawing surfaces *)
  type color   (* type of colors *)

  val create : string -> window * render
  (** creates a window and a rendering surface from the string s. The
      string is implementation defined *)

  val color : int -> int -> int -> int -> color
  (** returns a color built from components red green blue and alpha.
      all values must be integers between 0 and 255 inclusive. *)

  val fill_rect : render -> int -> int -> int -> int -> color -> unit
  (** fill_rect r x y w h c
      draws and fill a rectangle on render surface r at coordinates x y
      and with dimensions w * h. The rectangle is filled with color c *)

  val clear_rect : render -> int -> int -> int -> int -> unit
  (** clear_rect r x y w h
      Clears the rectangle of given coordinates and dimensions *)


  val draw_text : render -> string -> int -> int -> string -> unit
  (** draw_text r t x y f
      draws text t on render surface r at coordinates x y.
      f is a string describing the font, for instance "30px Arial"
   *)

  val poll_event : unit -> event
  (** Returns the next event in the event queue *)

  val main_loop : (float -> bool) -> unit
  (** Calls a rendering function f repeteadly but no faster than 60 times/seconds
      The callback f is given a float representing the time elapsed since the
      begining of the program. It should return true to continue being called or false
      to stop the main_loop
  *)

end