(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

let read_datum_from_lexbuf input =
  match Parser.parse_datum_from_lexbuf input with
  | None -> None
  | Some syntax -> Some (Semantic.analyze_node syntax)

let read_datum_from_channel input =
  Lexing.from_channel input |> read_datum_from_lexbuf

let read_datum input =
  Lexing.from_string input |> read_datum_from_lexbuf

let read_expression_from_lexbuf input =
  match Parser.parse_datum_from_lexbuf input with
  | None -> None
  | Some syntax -> Some (Semantic.analyze_node syntax)

let read_expression_from_channel input =
  Lexing.from_channel input |> read_expression_from_lexbuf

let read_expression input =
  Lexing.from_string input |> read_expression_from_lexbuf

let read_expressions_from_lexbuf input =
  match Parser.parse_data_from_lexbuf input with
  | [] -> []
  | syntax -> (List.map Semantic.analyze_node syntax)

let read_expressions_from_channel input =
  Lexing.from_channel input |> read_expressions_from_lexbuf

let read_expressions input =
  Lexing.from_string input |> read_expressions_from_lexbuf
