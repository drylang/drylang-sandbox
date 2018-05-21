(* This is free and unencumbered software released into the public domain. *)

(** AST node. *)

module Datum   = DRY.Core.Datum
module Symbol  = DRY.Core.Symbol
module Comment = DRY.Code.DRY.Comment

type t =
  | Literal of Datum.t
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

val of_bool : bool -> t
val of_char : char -> t
val of_float : float -> t
val of_int : int -> t

val to_string : t -> string

val print : Format.formatter -> t -> unit
