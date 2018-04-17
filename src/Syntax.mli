(* This is free and unencumbered software released into the public domain. *)

(** The syntax. *)

module Location   = DRY.Code.DRY.Location
module Expression = DRY.Code.DRY.Expression

module Node = Expression

module LocatedNode : sig
  type t = { expr: Node.t; source: Location.t }

  val create : Node.t -> t

  val create_with_pos : Node.t -> int -> int -> t

  val create_with_lexpos : Node.t -> Lexing.position -> t
end

module Error : sig
  type t = Lexical | Syntactic | Semantic
end

exception Error of Error.t * string

val lexical_error : string -> 'a
val syntactic_error : string -> 'a
val semantic_error : string -> 'a
