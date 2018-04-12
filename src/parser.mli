(* This is free and unencumbered software released into the public domain. *)

(** The parser. *)

val is_valid : string -> bool
val parse_from_lexbuf : Lexing.lexbuf -> Syntax.Expression.t option
val parse_from_channel : in_channel -> Syntax.Expression.t option
val parse_from_string : string -> Syntax.Expression.t option
