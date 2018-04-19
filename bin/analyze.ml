(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

module Stdlib = DRY__Stdlib

let main input =
  let source_context =
    let source_file =
      match input with None | Some "-" -> "stdin" | Some s -> s
    in
    let source_file = Stdlib.Filename.remove_extension source_file in
    let source_module = Stdlib.Filename.dirname source_file in
    let source_term = Stdlib.Filename.basename source_file in
    Syntax.Context.create source_file source_module source_term
  in
  let input_channel =
    match input with None | Some "-" -> stdin | Some s -> open_in s
  in
  let lexbuf = Lexing.from_channel input_channel in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some syntax -> begin
          let semantic = Semantic.analyze syntax in
          Printf.printf "%s\n%!" (Semantic.Node.to_string semantic)
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

let input =
  let doc = "The input file to analyze." in
  Arg.(value & pos 0 (some non_dir_file) None & info [] ~docv:"INPUT" ~doc)

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
  Term.(const main $ input),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
