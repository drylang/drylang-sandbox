(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

let main () =
  print_endline (String.concat " " ["dry-describe"; "release"; Drylang.Version.string])

let () = main ()
