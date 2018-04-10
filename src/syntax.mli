(* This is free and unencumbered software released into the public domain. *)

(** The syntax. *)

val is_valid : string -> bool
val parse_from_channel : in_channel -> Token.t
val parse_from_string : string -> Token.t
val tokenize : string -> Token.t list
