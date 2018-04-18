(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module PHP    = DRY.Code.PHP
module Target = Drylang.Target.PHP

let dry input =
  match Drylang.Parser.parse_from_string input with
  | None -> assert false
  | Some syntax -> Drylang.Semantic.analyze syntax

let () = assert (Target.compile_expr @@ dry "true" = "true")

let () = assert (Target.compile_expr @@ dry "false" = "false")

let () = assert (Target.compile_expr @@ dry "1.23" = "1.23")

let () = assert (Target.compile_expr @@ dry "42" = "42")