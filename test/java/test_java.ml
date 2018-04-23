(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Java   = DRY.Code.Java
module Target = (val (Drylang.Target.get "java") : Drylang.Target.Language)

let dry input =
  match Drylang.Parser.parse_from_string input with
  | None -> assert false
  | Some syntax -> Drylang.Semantic.analyze syntax

let () = assert (Target.compile_expr @@ dry "true" = "true")

let () = assert (Target.compile_expr @@ dry "false" = "false")

let () = assert (Target.compile_expr @@ dry "1.23" = "1.23d")

let () = assert (Target.compile_expr @@ dry "42" = "42L")
