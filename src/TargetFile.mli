(* This is free and unencumbered software released into the public domain. *)

type t =
  { channel: out_channel;
    path:    string;
    name:    string;
    ext:     string; }

val stdout : t

val open_file : string -> (t, [`Msg of string]) result

val to_string : t -> string
