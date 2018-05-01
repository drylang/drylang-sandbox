(* This is free and unencumbered software released into the public domain. *)

module Stdlib   = DRY__Stdlib
module Filename = Stdlib.Filename
module String   = Stdlib.String

type t =
  { channel: out_channel;
    path:    string;
    name:    string;
    ext:     string; }

let make channel ~path ~name ~ext =
  { channel; path; name; ext; }

let stdout =
  make Stdlib.stdout ~path:"/dev/stdout" ~name:"<stdout>" ~ext:""

let open_file path =
  let open Result in
  let ext = Filename.extension path in
  let ext =
    match String.sub ext 1 (String.length ext - 1) with
    | s -> s | exception Invalid_argument _ -> ""
  in
  match Stdlib.open_out path with
  | channel -> Ok (make channel ~path ~name:path ~ext)
  | exception Sys_error error ->
    Error (`Msg (Printf.sprintf "%s" error))

let to_string { name } = name
