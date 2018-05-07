(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

let parse_datum_from_lexbuf input =
  try (Some (Grammar.parse_one Lexer.lex input)) with
  | Token.EOF -> None
  | Grammar.Error -> Syntax.syntactic_error "invalid syntax"

let parse_data_from_lexbuf input =
  try Grammar.parse_all Lexer.lex input with
  | Token.EOF -> []
  | Grammar.Error -> Syntax.syntactic_error "invalid syntax"

let parse_datum_from_channel input =
  Lexing.from_channel input |> parse_datum_from_lexbuf

let parse_data_from_channel input =
  Lexing.from_channel input |> parse_data_from_lexbuf

let parse_datum input =
  Lexing.from_string input |> parse_datum_from_lexbuf

let parse_data input =
  Lexing.from_string input |> parse_data_from_lexbuf

let is_valid_datum string =
  match parse_datum string with
  | None -> false | Some _ -> true
  | exception Syntax.Error _ -> false

let is_valid_data string =
  match parse_data string with
  | [] -> false | _ :: _ -> true
  | exception Syntax.Error _ -> false
