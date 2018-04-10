(* This is free and unencumbered software released into the public domain. *)

(** The lexer. **)

module Exception : sig
  type t = Lexical | Syntactic | Semantic
end

exception Error of Exception.t * string

val lex : Lexing.lexbuf -> Token.t
