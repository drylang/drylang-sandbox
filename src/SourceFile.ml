(* This is free and unencumbered software released into the public domain. *)

type t =
  { name: string;
    path: string;
    channel: in_channel; }

let stdin =
  { name = "<stdin>";
    path = "/dev/stdin";
    channel = stdin; }

let from_path path =
  { name = path;
    path;
    channel = open_in path; }

let to_string { name } = name
