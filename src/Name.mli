(* This is free and unencumbered software released into the public domain. *)

(** Names. *)

module Symbol = DRY.Core.Symbol

type t = Symbol.t * Symbol.t list

val make : ?package:string -> string -> t

val of_string : string -> t

val to_string : t -> string
