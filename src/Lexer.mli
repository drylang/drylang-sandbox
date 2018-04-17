(* This is free and unencumbered software released into the public domain. *)

(** The lexer. **)

val lex : Lexing.lexbuf -> Token.t
val lex_from_string : string -> Token.t
val tokenize : string -> Token.t list
