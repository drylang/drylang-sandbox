(* This is free and unencumbered software released into the public domain. *)

(** The parser. *)

val is_valid : string -> bool
val parse_from_lexbuf : Lexing.lexbuf -> Syntax.Node.t option
val parse_from_channel : in_channel -> Syntax.Node.t option
val parse_from_string : string -> Syntax.Node.t option
