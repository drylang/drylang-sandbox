(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

module Stdlib = DRY__Stdlib
module Format = Stdlib.Format

let main (input : SourceFile.t) options =
  let output_formatter = Format.std_formatter in
  let lexbuf = Lexing.from_channel input.channel in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some syntax -> begin
          let semantic = Semantic.analyze_node syntax in
          Semantic.Node.print output_formatter semantic;
          Format.pp_print_newline output_formatter ()
        end
    with
    | Syntax.Error (Lexical, message) ->
      Printf.eprintf "lexical error: %s\n%!" message;
      exit 1
    | Syntax.Error (Syntactic, message) ->
      Printf.eprintf "syntax error: %s\n%!" message;
      exit 1
    | Syntax.Error (Semantic, message) ->
      Printf.eprintf "semantic error: %s\n%!" message;
      exit 1
  done

(* Command-line interface *)

open Cmdliner

let input = Options.source_file 0 "The input file to analyze."

let cmd =
  let name = "dry-analyze" in
  let version = Version.string in
  let doc = "analyze DRY code" in
  let exits = Term.default_exits in
  let envs = [] in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1), $(b,dry-analyze)(1)" ]
  in
  Term.(const main $ input $ Options.common),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
