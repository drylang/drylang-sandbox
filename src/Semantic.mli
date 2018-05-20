(* This is free and unencumbered software released into the public domain. *)

(** Semantic analysis. *)

module Datum   = DRY.Core.Datum
module Symbol  = DRY.Core.Symbol
module Comment = DRY.Code.DRY.Comment

module Node : sig
  type t =
    | Const of Datum.t
    | Id of Symbol.t
    | Name of Name.t
    | Import of Name.t list
    | Export of Name.t list
    | Apply of t * t list
    | MathNeg of t
    | MathAdd of t * t
    | MathSub of t * t
    | MathMul of t * t
    | MathDiv of t * t
    | LogicNot of t
    | LogicAnd of t * t
    | LogicOr of t * t
    | If of t * t * t
    | Loop of t list

  val to_string : t -> string

  val print : Format.formatter -> t -> unit
end

(* Semantic analysis *)

val analyze_node : Syntax.Node.t -> Node.t
