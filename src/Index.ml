(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Stdlib = DRY__Stdlib

type t = Unix.dir_handle

let default_path () =
  let getenv = Stdlib.Sys.getenv_opt in
  let home_dir = match getenv("HOME") with Some s -> s | None -> "" in
  Stdlib.Filename.concat home_dir ".dry"

let open_path path =
  Unix.opendir path

let open_default () =
  open_path (default_path ())
