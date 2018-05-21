(* This is free and unencumbered software released into the public domain. *)

(** Semantic analysis. *)

module Datum   = DRY.Core.Datum
module Symbol  = DRY.Core.Symbol
module Comment = DRY.Code.DRY.Comment

(* Semantic analysis *)

val analyze_node : Syntax.Node.t -> Node.t
