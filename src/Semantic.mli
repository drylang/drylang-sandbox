(* This is free and unencumbered software released into the public domain. *)

(** Semantic analysis. *)

module Datum   = DRY.Core.Datum
module Symbol  = DRY.Core.Symbol
module Comment = DRY.Code.DRY.Comment

module Node : sig
  type t =
    | Const of Datum.t
    | Var of Symbol.t
    | Apply of t * t list
    | Not of t
    | And of t * t
    | Or of t * t
    | If of t * t * t
    | Add of t * t
    | Sub of t * t
    | Mul of t * t
    | Div of t * t

  val to_string : t -> string

  val print : Format.formatter -> t -> unit
end

module Module : sig
  type t =
    { name: Symbol.t;
      comment: Comment.t option;
      code: Node.t list; }

  val make :
    ?comment:string ->
    name:string ->
    t

  val print : Format.formatter -> t -> unit
end

module Program : sig
  type t = Node.t list

  val make : Node.t list -> t

  val print : Format.formatter -> t -> unit
end

val analyze : Syntax.Node.t -> Node.t

val analyze_module : Syntax.Context.t -> Syntax.Node.t -> Module.t
