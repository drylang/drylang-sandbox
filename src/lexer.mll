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
}

let digit = ['0'-'9']
let frac  = '.' digit*
let exp   = ['e' 'E'] ['-' '+']? digit+

let float = digit* frac? exp?
let int   = '-'? digit+

let ident = ['A'-'Z' 'a'-'z' '_']['0'-'9' 'A'-'Z' 'a'-'z' '_' '-']*

rule lex = parse
  | '\n'       { Lexing.new_line lexbuf; lex lexbuf }
  | [' ' '\t'] { lex lexbuf }
  | ';'        { comment lexbuf; lex lexbuf }
  | int as n   { Token.INTEGER (int_of_string n) }
  | float as f { Token.FLOAT (float_of_string f) }
  | ident as s { Token.SYMBOL (s) }
  | eof        { Token.EOF }
  | _          { lexical_error (Printf.sprintf "unexpected character at %s" (format_lexbuf_pos lexbuf)) }

and comment = parse
  | '\n'       { Lexing.new_line lexbuf }
  | eof        { () }
  | _          { comment lexbuf }

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
