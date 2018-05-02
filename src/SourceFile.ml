(* This is free and unencumbered software released into the public domain. *)

module Stdlib   = DRY__Stdlib
module Filename = Stdlib.Filename

type t =
  { channel: in_channel;
    path:    string;
    name:    string;
    package: string;
    module_: string;
    term:    string; }

let make channel ~path ~name ~package ~module_ ~term =
  { channel; path; name; package; module_; term; }

let stdin =
  { channel = Stdlib.stdin;
    path    = "/dev/stdin";
    name    = "<stdin>";
    package = "user";
    module_ = "program";
    term    = "main"; }

let open_user_program file_path =
  { channel = open_in file_path;
    path    = file_path;
    name    = Filename.remove_extension file_path;
    package = "user";
    module_ = Filename.dirname file_path; (* FIXME *)
    term    = Filename.basename file_path; } (* FIXME *)

let open_package_term ~index ~package term_path =
  let file_path = Printf.sprintf "%s/%s/%s.dry" index package term_path in
  { channel = open_in file_path;
    path    = file_path;
    name    = term_path;
    package = package;
    module_ = Filename.dirname file_path;
    term    = Filename.basename file_path; }

let to_string { name } = name
