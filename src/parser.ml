(* This is free and unencumbered software released into the public domain. *)

let parse_from_lexbuf input =
  Grammar.parse Lexer.lex input

let parse_from_channel input =
  Lexing.from_channel input |> parse_from_lexbuf

let parse_from_string input =
  Lexing.from_string input |> parse_from_lexbuf

let is_valid string =
  try (parse_from_string string |> ignore; true) with
  | Syntax.Error _ | Grammar.Error -> false
