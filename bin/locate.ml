(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

let main term =
  print_endline term (* TODO *)

(* Command-line interface *)

open Cmdliner

let term =
  let doc = "The term to locate." in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"TERM" ~doc)

let cmd =
  let name = "dry-locate" in
  let version = Version.string in
  let doc = "locate the source file for a DRY term" in
  let exits = Term.default_exits in
  let envs =
    let doc = "Overrides the default package index (~/.dry)." in
    let root = Arg.env_var "DRY_ROOT" ~doc in
    [root]
  in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1)" ]
  in
  Term.(const main $ term),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
