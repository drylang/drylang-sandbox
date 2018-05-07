(* This is free and unencumbered software released into the public domain. *)

(** The parser. *)

val is_valid_datum : string -> bool
val is_valid_data : string -> bool

val parse_datum_from_lexbuf : Lexing.lexbuf -> Syntax.Node.t option
val parse_datum_from_channel : in_channel -> Syntax.Node.t option
val parse_datum_from_string : string -> Syntax.Node.t option

val parse_data_from_lexbuf : Lexing.lexbuf -> Syntax.Node.t list
val parse_data_from_channel : in_channel -> Syntax.Node.t list
val parse_data_from_string : string -> Syntax.Node.t list
