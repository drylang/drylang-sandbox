(* This is free and unencumbered software released into the public domain. *)

(** The syntax. *)

val is_valid : string -> bool
val parse_from_channel : in_channel -> Code.Expression.t
val parse_from_string : string -> Code.Expression.t
val tokenize : string -> Token.t list
