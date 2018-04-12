(* This is free and unencumbered software released into the public domain. *)

{
let lexical_error = Syntax.lexical_error
}

let digit = ['0'-'9']
let frac  = '.' digit*
let exp   = ['e' 'E'] ['-' '+']? digit+

let float = digit* frac? exp?
let int   = '-'? digit+

let ident = ['A'-'Z' 'a'-'z' '_']['0'-'9' 'A'-'Z' 'a'-'z' '_' '-']*

rule lex = parse
  | [' ' '\t' '\n']
  { lex lexbuf } (* skip whitespace *)

  | int as n
  { Token.INTEGER (int_of_string n) }

  | float as f
  { Token.FLOAT (float_of_string f) }

  | ident as s
  { Token.SYMBOL (s) }

  | eof
  { Token.EOF }

  | _
  { lexical_error (Printf.sprintf "unexpected character at offset %d" (Lexing.lexeme_start lexbuf)) }

{
let lex_from_string input =
  Lexing.from_string input |> lex

let tokenize input =
  let lexbuf_to_list lexbuf =
    let rec consume input output =
      match lex input with
      | Token.EOF -> output
      | token -> consume input (token :: output)
    in List.rev (consume lexbuf [])
  in
  Lexing.from_string input |> lexbuf_to_list
}
