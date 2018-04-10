(* This is free and unencumbered software released into the public domain. *)

let parse_from_lexbuf input =
  Lexer.lex input

let parse_from_channel input =
  Lexing.from_channel input |> parse_from_lexbuf

let parse_from_string input =
  Lexing.from_string input |> parse_from_lexbuf

let is_valid string =
  try (parse_from_string string |> ignore; true) with
  | Lexer.Error _ -> false

let tokenize input =
  let lexbuf_to_list lexbuf =
    let rec consume input output =
      match Lexer.lex input with
      | Token.EOF -> output
      | token -> consume input (token :: output)
    in List.rev (consume lexbuf [])
  in
  Lexing.from_string input |> lexbuf_to_list
