(* This is free and unencumbered software released into the public domain. *)

(** Names. *)

type t = string * string list

val make : ?package:string -> string -> t

val of_string : string -> t

val to_string : t -> string

val package : t -> string
val dirname : ?sep:string -> t -> string
val basename : t -> string
