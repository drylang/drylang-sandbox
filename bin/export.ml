(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

module Stdlib = DRY__Stdlib
module Buffer = Stdlib.Buffer
module Printf = Stdlib.Printf
module String = Stdlib.String

let warn = Printf.eprintf

let main root term output =
  let target_ext = Stdlib.Filename.extension output in
  let target_ext =
    match String.sub target_ext 1 (String.length target_ext - 1) with
    | exception Invalid_argument _ ->
      warn "invalid output file name: %s\n%!" output;
      exit 1
    | "" ->
      warn "invalid output file extension: %s\n%!" output;
      exit 1
    | s -> s
  in
  let lexbuf = Lexing.from_channel stdin in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some syntax ->
        begin match Target.by_extension target_ext with
        | None -> warn "invalid target language%s\n%!"; exit 1
        | Some (module L : Target.Language) ->
          let code = Semantic.analyze syntax in
          let buffer = Buffer.create 16 in
          L.compile code buffer;
          Buffer.output_buffer stdout buffer;
          Printf.printf "\n%!"
        end
    with
    | Syntax.Error (Lexical, message) ->
      warn "lexical error: %s\n%!" message;
      exit 1
    | Syntax.Error (Syntactic, message) ->
      warn "syntax error: %s\n%!" message;
      exit 1
    | Syntax.Error (Semantic, message) ->
      warn "semantic error: %s\n%!" message;
      exit 1
  done

(* Command-line interface *)

open Cmdliner

let term =
  let doc = "The term to export." in
  Arg.(value & pos 0 (some string) None & info [] ~docv:"TERM" ~doc)

let output =
  let doc = "The output file name." in
  Arg.(value & opt string "out.c" & info ["o"; "output"] ~docv:"OUTPUT" ~doc)

let root =
  let doc = "Overrides the default package index (\\$HOME/.dry)." in
  let env = Arg.env_var "DRY_ROOT" ~doc in
  let doc = "The package index root." in
  let def = Index.default_path () in
  Arg.(value & opt dir def & info ["root"] ~env ~docv:"ROOT" ~doc)

let cmd =
  let name = "dry-export" in
  let version = Version.string in
  let doc = "export a DRY term" in
  let exits = Term.default_exits in
  let envs = [] in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1)" ]
  in
  Term.(const main $ root $ term $ output),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
