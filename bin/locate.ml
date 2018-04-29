(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

let main root term options =
  let package = "drylib" in
  let path = Printf.sprintf "%s/%s/%s.dry" root package term in
  Printf.printf "%s\n%!" path

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
  let envs = [] in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1), $(b,dry-describe)(1)" ]
  in
  Term.(const main $ Options.PackageRoot.term $ term $ Options.term),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
