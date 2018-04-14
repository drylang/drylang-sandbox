(* This is free and unencumbered software released into the public domain. *)

(** Semantic analysis. *)

module Datum  = Dry.Core.Datum
module Symbol = Dry.Core.Symbol

module Node : sig
  type t =
    | Const of Datum.t
    | Var of Symbol.t
    | Apply of t * t list
    | And of t * t
    | Or of t * t
    | If of t * t * t

  val to_string : t -> string
end

val analyze : Syntax.Node.t -> Node.t
