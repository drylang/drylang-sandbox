(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Wasm   = DRY.Code.Wasm
module Target = (val (Drylang.Target.get "wast") : Drylang.Target.Language)

let dry input =
  match Drylang.Parser.parse_from_string input with
  | None -> assert false
  | Some syntax -> Drylang.Semantic.analyze syntax

let () = assert (Target.compile_expr @@ dry "true" = "1")

let () = assert (Target.compile_expr @@ dry "false" = "0")

let () = assert (Target.compile_expr @@ dry "1.23" = "1.23")

let () = assert (Target.compile_expr @@ dry "42" = "42")
