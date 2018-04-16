(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Cli

let main () =
  print_endline (String.concat " " ["dry-describe"; "release"; Cli.Version.string])

let () = main ()
