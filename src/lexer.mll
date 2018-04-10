(* This is free and unencumbered software released into the public domain. *)

{
module Exception = struct
  type t = Lexical | Syntactic | Semantic
end

exception Error of Exception.t * string

let lexical_error message =
  raise (Error (Lexical, message))

let syntactic_error message =
  raise (Error (Syntactic, message))

let semantic_error message =
  raise (Error (Semantic, message))
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
