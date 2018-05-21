(* This is free and unencumbered software released into the public domain. *)

(** Program representation. *)

type t = { code: Node.t list; }

val make : Node.t list -> t

val print : Format.formatter -> t -> unit

val optimize : SourceFile.t -> t -> t
