(* This is free and unencumbered software released into the public domain. *)

open Dry.Core

let parse_from_lexbuf input =
  try (Some (Grammar.parse Lexer.lex input)) with
  | Token.EOF -> None
  | Grammar.Error -> Syntax.syntactic_error "invalid syntax"

let parse_from_channel input =
  Lexing.from_channel input |> parse_from_lexbuf

let parse_from_string input =
  Lexing.from_string input |> parse_from_lexbuf

let is_valid string =
  match parse_from_string string with
  | Some _ -> true | None -> false
  | exception Syntax.Error _ -> false
