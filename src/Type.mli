(* This is free and unencumbered software released into the public domain. *)

(** Types. *)

type t =
  | Any
  | Bit
  | Bool
  | Char
  | Error
  | Function of t * t
  | Interval of t
  | Map of t * t
  | Matrix of t
  | None
  | Number
  | Option of t
  | Quantity of t
  | Result of t
  | Seq of t
  | Set of t
  | String
  | Symbol
  | Tuple2 of t * t
  | Tuple3 of t * t * t
  | Tuple4 of t * t * t * t
  | Type
  | Unit
  | Word

val of_node : Node.t -> t
val of_term : DRY.Core.Datum.t -> t

val to_string : t -> string
