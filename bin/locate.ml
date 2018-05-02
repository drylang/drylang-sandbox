(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

let main root term options =
  let package = "drylib" in
  let path = Printf.sprintf "%s/%s/%s.dry" root package term in
  Printf.printf "%s\n%!" path

(* Command-line interface *)

open Cmdliner

let term = Options.required_term 0 "The term to locate."

let cmd =
  let name = "dry-locate" in
  let version = Version.string in
  let doc = "locate the source file for a DRY term" in
  let exits = Term.default_exits in
  let envs = [] in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1), $(b,dry-describe)(1), $(b,dry-index)(1)" ]
  in
  Term.(const main $ Options.package_root $ term $ Options.common),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
