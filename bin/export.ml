(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

module Stdlib = DRY__Stdlib
module Buffer = Stdlib.Buffer
module Format = Stdlib.Format
module String = Stdlib.String

let warn = Stdlib.Printf.eprintf

let main root input output language options =
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
  let target_ext =
    match language with
    | "" -> target_ext
    | s -> if Target.is_supported s then s else begin
        warn "unknown output language: %s\n%!" s;
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
  let output_formatter =
    match output with
    | "" | "-" -> Format.std_formatter
    | s -> Stdlib.open_out s |> Format.formatter_of_out_channel
  in
  let lexbuf = Lexing.from_channel input_channel in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some syntax ->
        begin match Target.by_extension target_ext with
        | None -> assert false
        | Some (module L : Target.Language) ->
          let code = Semantic.analyze_program source_context syntax in
          L.compile_program output_formatter code;
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

let term = Options.optional_term 0 "The term to export."

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
  Term.(const main $ Options.package_root $ term $ Options.output_file $ Options.output_language $ Options.common),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
