(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

let main root term =
  print_endline term (* TODO *)

(* Command-line interface *)

open Cmdliner

let term =
  let doc = "The term to describe." in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"TERM" ~doc)

let root =
  let doc = "Overrides the default package index (~/.dry)." in
  let env = Arg.env_var "DRY_ROOT" ~doc in
  let doc = "The package index root." in
  Arg.(value & opt dir "~/.dry" & info ["root"] ~env ~docv:"ROOT" ~doc)

let cmd =
  let name = "dry-describe" in
  let version = Version.string in
  let doc = "describe a DRY term" in
  let exits = Term.default_exits in
  let envs = [] in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1), $(b,dry-locate)(1)" ]
  in
  Term.(const main $ root $ term),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
