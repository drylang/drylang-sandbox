(* This is free and unencumbered software released into the public domain. *)

(** Package index. **)

type t

val default_path : unit -> string

val open_default : unit -> t

val open_path : string -> t
