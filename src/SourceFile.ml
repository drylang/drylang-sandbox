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
  { channel = stdin;
    path    = "/dev/stdin";
    name    = "<stdin>";
    package = "user";
    module_ = "stdin";
    term    = ""; }

let open_user_program path =
  { channel = open_in path;
    path;
    name    = Filename.remove_extension path;
    package = "user";
    module_ = Filename.dirname path; (* FIXME *)
    term    = Filename.basename path; } (* FIXME *)

let open_drylib_term path =
  { channel = open_in path;
    path;
    name    = Filename.remove_extension path;
    package = "drylib";
    module_ = Filename.dirname path; (* FIXME *)
    term    = Filename.basename path; } (* FIXME *)

let to_string { name } = name
