(* This is free and unencumbered software released into the public domain. *)

open Dry.Core
open Cli

let () =
  print_endline (String.concat " " ["dry-export"; "release"; Cli.Version.string])
