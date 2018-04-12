(* This is free and unencumbered software released into the public domain. *)

{
let lexical_error = Syntax.lexical_error

let format_lexbuf_pos lexbuf =
  let pos = (Lexing.lexeme_start_p lexbuf) in
  let fname = pos.pos_fname in
  let lnum = pos.pos_lnum in
  let cnum = ((pos.pos_cnum - pos.pos_bol) + 1) in
  match fname with
  | "" -> Printf.sprintf "%d:%d" lnum cnum
  | _  -> Printf.sprintf "%s:%d:%d" fname lnum cnum

let unexpected_eof lexbuf =
  lexical_error (Printf.sprintf "unexpected end of input at %s" (format_lexbuf_pos lexbuf))

let unexpected_lf lexbuf =
  lexical_error (Printf.sprintf "unexpected line break at %s" (format_lexbuf_pos lexbuf))

let unexpected_char lexbuf =
  lexical_error (Printf.sprintf "unexpected character at %s" (format_lexbuf_pos lexbuf))
}

let digit = ['0'-'9']
let frac  = '.' digit*
let exp   = ['e' 'E'] ['-' '+']? digit+

let float = digit* frac? exp?
let int   = '-'? digit+

let ident = ['A'-'Z' 'a'-'z' '_']['0'-'9' 'A'-'Z' 'a'-'z' '_' '-']*

let whitespace = [' ' '\t']+
let newline = '\n'

rule lex = parse
  | whitespace { lex lexbuf }
  | newline    { Lexing.new_line lexbuf; lex lexbuf }
  | ';'        { lex_comment lexbuf; lex lexbuf }
  | "\n\"\"\"" { Lexing.new_line lexbuf; lex_doc_begin (Buffer.create 16) lexbuf }
  | '"'        { lex_string (Buffer.create 16) lexbuf }
  | int as n   { Token.INTEGER (int_of_string n) }
  | float as f { Token.FLOAT (float_of_string f) }
  | ident as s { Token.SYMBOL s }
  | _          { unexpected_char lexbuf }
  | eof        { Token.EOF }

and lex_comment = parse
  | '\n'       { Lexing.new_line lexbuf }
  | _          { lex_comment lexbuf }
  | eof        { () }

and lex_string buf = parse
  | newline    { unexpected_lf lexbuf }
  | '"'        { Token.STRING (Buffer.contents buf) }
  | [^ '"']    { Buffer.add_string buf (Lexing.lexeme lexbuf); lex_string buf lexbuf }
  | eof        { unexpected_eof lexbuf }

and lex_doc_begin buf = parse
  | '"'*       { lex_doc_begin buf lexbuf }
  | "\n\"\"\"" { Lexing.new_line lexbuf; lex_doc_end buf lexbuf } (* empty docstring *)
  | newline    { Lexing.new_line lexbuf; lex_doc_string buf lexbuf }
  | _          { unexpected_char lexbuf }
  | eof        { unexpected_eof lexbuf }

and lex_doc_string buf = parse
  | "\n\"\"\"" { Lexing.new_line lexbuf; lex_doc_end buf lexbuf }
  | newline    { Buffer.add_string buf (Lexing.lexeme lexbuf); Lexing.new_line lexbuf; lex_doc_string buf lexbuf }
  | _          { Buffer.add_string buf (Lexing.lexeme lexbuf); lex_doc_string buf lexbuf }
  | eof        { unexpected_eof lexbuf }

and lex_doc_end buf = parse
  | '"'*       { lex_doc_end buf lexbuf }
  | newline    { Lexing.new_line lexbuf; Token.STRING (Buffer.contents buf) }
  | _          { unexpected_char lexbuf }
  | eof        { unexpected_eof lexbuf }

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
