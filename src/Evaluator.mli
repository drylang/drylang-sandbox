(* This is free and unencumbered software released into the public domain. *)

(** The evaluator (aka interpreter). *)

module Datum = DRY.Core.Datum
module Int8  = DRY.Core.Int8

val eval_expression : Node.t -> Datum.t
val eval_expressions : Node.t list -> Datum.t
val eval_program : Program.t -> Datum.t
val eval_script : Program.t -> Datum.t
