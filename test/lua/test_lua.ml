(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Lua    = DRY.Code.Lua
module Target = (val (Drylang.Target.get "lua") : Drylang.Target.Language)

let compile code =
  let buffer = Buffer.create 16 in
  let ppf = Format.formatter_of_buffer buffer in
  Target.compile_node ppf code;
  Format.pp_print_flush ppf ();
  Buffer.contents buffer

let dry input =
  match Drylang.Parser.parse_datum input with
  | None -> assert false
  | Some syntax -> Drylang.Semantic.analyze_node syntax

let () = assert (compile @@ dry "true" = "true")

let () = assert (compile @@ dry "false" = "false")

let () = assert (compile @@ dry "1.23" = "1.23")

let () = assert (compile @@ dry "42" = "42")
