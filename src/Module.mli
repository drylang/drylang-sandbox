(* This is free and unencumbered software released into the public domain. *)

(** Module representation. *)

module Comment = DRY.Code.DRY.Comment
module Node    = Semantic.Node
module Symbol  = DRY.Core.Symbol

type t =
  { name: Symbol.t;
    comment: Comment.t option;
    code: Node.t list; }

val make :
  ?comment:string ->
  name:string ->
  code:Node.t list ->
  t

val print : Format.formatter -> t -> unit

val optimize : SourceFile.t -> t -> t
