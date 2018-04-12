(* This is free and unencumbered software released into the public domain. *)

(** The syntax. *)

module Expression = Dry.Code.DRY.Expression

module Error : sig
  type t = Lexical | Syntactic | Semantic
end

exception Error of Error.t * string

val lexical_error : string -> 'a
val syntactic_error : string -> 'a
val semantic_error : string -> 'a
