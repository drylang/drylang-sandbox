(* This is free and unencumbered software released into the public domain. *)

(** Semantic analysis. *)

module Datum = Dry.Core.Datum

module Node : sig
  type t =
    | Const of Datum.t
    | Call of t * t list

  val to_string : t -> string
end

val analyze : Syntax.Node.t -> Node.t
