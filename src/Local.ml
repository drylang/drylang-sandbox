(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Stdlib = DRY__Stdlib
module Sys    = Stdlib.Sys

let concat_path = Stdlib.Filename.concat

let is_source_file path =
  (not (Sys.is_directory path)) &&
  (Stdlib.Filename.extension path) = ".dry"

let is_module_dir path =
  Sys.is_directory path &&
  Sys.file_exists (concat_path path ".drymodule")

let is_package_dir path =
  Sys.is_directory path &&
  Sys.file_exists (concat_path path ".drypackage")

module Term = struct
  type t =
    { name: Symbol.t;
      path: string;
      filepath: string; }

  let make ?(filepath = "") ?(path = "") name =
    { name = Symbol.of_string name;
      path = path;
      filepath = filepath; }

  let to_string term = ""
end

module Module = struct
  type t =
    { name: Symbol.t;
      path: string;
      dirpath: string; }

  let make ?(dirpath = "") ?(path = "") name =
    { name = Symbol.of_string name;
      path = path;
      dirpath = dirpath; }

  let iter mod_ fn =
    let dir = Unix.opendir mod_.dirpath in
    try
      while true do
        match Unix.readdir dir with
        | "." | ".." -> ()
        | name ->
          let filepath = concat_path mod_.dirpath name in
          let name = (Stdlib.Filename.remove_extension name) in
          let path = mod_.path ^ "/" ^ name in
          if is_source_file filepath then (fn @@ Term.make name ~path ~filepath) else ()
      done
    with End_of_file -> ()

  let to_string mod_ = ""
end

module Package = struct
  type t =
    { name: Symbol.t;
      path: string;
      dirpath: string; }

  let make ?(dirpath = "") ?(path = "") name =
    { name = Symbol.of_string name;
      path = path;
      dirpath = dirpath; }

  let iter pkg fn =
    let dir = Unix.opendir pkg.dirpath in
    try
      while true do
        match Unix.readdir dir with
        | "." | ".." -> ()
        | name ->
          let dirpath = concat_path pkg.dirpath name in
          let path = pkg.path ^ "/" ^ name in
          if is_module_dir dirpath then (fn @@ Module.make name ~path ~dirpath) else ()
      done
    with End_of_file -> ()

  let to_string pkg = pkg.dirpath
end

module Index = struct
  type t =
    { dirpath: string; }

  let default_path () =
    let getenv = Stdlib.Sys.getenv_opt in
    let home_dir = match getenv("HOME") with Some s -> s | None -> "" in
    concat_path home_dir ".dry"

  let open_path dirpath =
    { dirpath = dirpath; }

  let open_default () =
    open_path (default_path ())

  let iter idx fn =
    let dir = Unix.opendir idx.dirpath in
    try
      while true do
        match Unix.readdir dir with
        | "." | ".." -> ()
        | name ->
          let dirpath = concat_path idx.dirpath name in
          let path = "//" ^ name in
          if is_package_dir dirpath then (fn @@ Package.make name ~path ~dirpath) else ()
      done
    with End_of_file -> ()

  let to_string idx = idx.dirpath
end
