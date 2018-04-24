(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

module Stdlib = DRY__Stdlib
module Buffer = Stdlib.Buffer
module Format = Stdlib.Format
module String = Stdlib.String

let warn = Stdlib.Printf.eprintf

let main root input output =
  let target_ext = Stdlib.Filename.extension output in
  let target_ext =
    match String.sub target_ext 1 (String.length target_ext - 1) with
    | exception Invalid_argument _ ->
      warn "missing output file extension: %s\n%!" output;
      exit 1
    | "" ->
      warn "invalid output file extension: %s\n%!" output;
      exit 1
    | s -> if Target.is_supported s then s else begin
        warn "unknown output file extension: %s\n%!" s;
        exit 1
      end
  in
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
  let output_formatter = Format.std_formatter in
  let lexbuf = Lexing.from_channel input_channel in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some syntax ->
        begin match Target.by_extension target_ext with
        | None -> assert false
        | Some (module L : Target.Language) ->
          let code = Semantic.analyze_module source_context syntax in
          L.compile_module output_formatter code;
          Format.pp_print_newline output_formatter ()
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
  Arg.(value & opt string "out.java" & info ["o"; "output"] ~docv:"OUTPUT" ~doc)

let root =
  let doc = "Overrides the default package index (\\$HOME/.dry)." in
  let env = Arg.env_var "DRY_ROOT" ~doc in
  let doc = "The package index root." in
  let def = Local.Index.default_path () in
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
