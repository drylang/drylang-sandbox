(* This is free and unencumbered software released into the public domain. *)

type t =
  { name: string;
    path: string;
    channel: in_channel; }

val stdin : t

val from_path : string -> t

val to_string : t -> string
