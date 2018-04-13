(* This is free and unencumbered software released into the public domain. *)

(** The syntax. *)

module Source : sig
  type t = { line: int; column: int }

  val unknown : t
end

module Expression = Dry.Code.DRY.Expression

module Node : sig
  type t = { expr: Expression.t; source: Source.t }

  val create : Expression.t -> t
end

module Error : sig
  type t = Lexical | Syntactic | Semantic
end

exception Error of Error.t * string

val lexical_error : string -> 'a
val syntactic_error : string -> 'a
val semantic_error : string -> 'a
