(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

(* Datum *)

let read_datum_from_lexbuf input =
  match Parser.parse_datum_from_lexbuf input with
  | None -> None
  | Some syntax -> Some (Semantic.analyze_node syntax)

let read_datum_from_channel input =
  Lexing.from_channel input |> read_datum_from_lexbuf

let read_datum input =
  Lexing.from_string input |> read_datum_from_lexbuf

(* Expression *)

let read_expression_from_lexbuf input =
  match Parser.parse_datum_from_lexbuf input with
  | None -> None
  | Some syntax -> Some (Semantic.analyze_node syntax)

let read_expression_from_channel input =
  Lexing.from_channel input |> read_expression_from_lexbuf

let read_expression input =
  Lexing.from_string input |> read_expression_from_lexbuf

(* Expressions *)

let read_expressions_from_lexbuf input =
  match Parser.parse_data_from_lexbuf input with
  | [] -> []
  | syntax -> (List.map Semantic.analyze_node syntax)

let read_expressions_from_channel input =
  Lexing.from_channel input |> read_expressions_from_lexbuf

let read_expressions input =
  Lexing.from_string input |> read_expressions_from_lexbuf

(* Module *)

let read_module_from_lexbuf ?(name = "") input =
  match Parser.parse_data_from_lexbuf input with
  | [] -> None
  | syntax -> Some (Semantic.Module.make name (List.map Semantic.analyze_node syntax))

let read_module_from_channel ?(name = "") input =
  Lexing.from_channel input |> read_module_from_lexbuf ~name

let read_module ?(name = "") input =
  Lexing.from_string input |> read_module_from_lexbuf ~name

(* Program *)

let read_program_from_lexbuf input =
  match Parser.parse_data_from_lexbuf input with
  | [] -> None
  | syntax -> Some (Program.make (List.map Semantic.analyze_node syntax))

let read_program_from_channel input =
  Lexing.from_channel input |> read_program_from_lexbuf

let read_program input =
  Lexing.from_string input |> read_program_from_lexbuf

(* Script *)

let read_script_from_lexbuf input =
  match Parser.parse_data_from_lexbuf input with
  | [] -> None
  | syntax -> Some (Program.make (List.map Semantic.analyze_node syntax))

let read_script_from_channel input =
  Lexing.from_channel input |> read_script_from_lexbuf

let read_script input =
  Lexing.from_string input |> read_script_from_lexbuf
