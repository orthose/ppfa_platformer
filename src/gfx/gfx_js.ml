open Js_of_ocaml


type window = Dom_html.canvasElement Js.t
type render = Dom_html.canvasRenderingContext2D Js.t
type color = string

let events = Queue.create ()
let create s =
  match Dom_html.getElementById_coerce s Dom_html.CoerceTo.canvas with
     None -> raise (Gfx_base.GfxError ("Gfx_js: cannot find canvas with id " ^ s))
   | Some canvas ->
      let ctx = canvas ##getContext Dom_html._2d_ in
      canvas ##. onkeydown := Dom_html.handler (fun e ->
        Js.Optdef.iter e ##.key (fun k -> 
          Queue.add (Gfx_base.KeyDown (Js.to_string k)) events);
        Js._true);
      canvas ##. onkeyup := Dom_html.handler (fun e ->
        Js.Optdef.iter e ##.key (fun k -> 
          Queue.add (Gfx_base.KeyUp (Js.to_string k)) events);
        Js._true);
      (canvas, ctx)
      
let color r g b a = 
  "rgba(" ^ string_of_int r ^ ", " ^
            string_of_int g ^ ", " ^
            string_of_int b ^ ", " ^
            string_of_float (float a /. 255.) ^ "0)" (* work around:
            Ocaml generates the literal for string_of_float (1.0) "1.",
            which is not supported by the rgba syntax. It's always safe
            to add a trainling 0 in this case, since the number is either:
            0. → 0.0
            1. -> 1.0
            0.2423 -> 0.24230
*)
let clear_rect (ctx : render) x y w h = 
  ctx ## clearRect (float x) (float y) (float w) (float h)
let fill_rect (ctx : render) x y w h c =
  (* Firebug.console ## log (Js.string c); *)
    ctx ##. fillStyle := Js.string c;
    ctx ## fillRect (float x) (float y) (float w) (float h)


let draw_text (ctx : render) text x y font =
  ctx ##. font := Js.string font;
  ctx ## fillText (Js.string text) (float x) (float y)

let poll_event () =
  if Queue.is_empty events then Gfx_base.NoEvent
  else Queue.pop events

let main_loop f =
  let cb = ref (Js.wrap_callback (fun _ -> ())) in
  let loop dt =
      if f dt then
        ignore (Dom_html.window ## requestAnimationFrame (!cb))
  in
  cb := Js.wrap_callback loop;
  ignore (Dom_html.window ## requestAnimationFrame !cb)
