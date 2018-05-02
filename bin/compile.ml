(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

module Stdlib = DRY__Stdlib
module Format = Stdlib.Format

let warn = Stdlib.Printf.eprintf

let main root (input : SourceFile.t) (output : TargetFile.t) language options =
  let output_ext = match output.ext with "" -> "dry" | s -> s in
  let output_ext = match language with Some s -> s | None -> output_ext in
  let output_ppf = Format.formatter_of_out_channel output.channel in
  let input_lexbuf = Lexing.from_channel input.channel in
  while true do
    try
      match Parser.parse_from_lexbuf input_lexbuf with
      | None -> exit 0
      | Some syntax ->
        begin match Target.by_extension output_ext with
        | None -> assert false
        | Some (module L : Target.Language) ->
          let code = Semantic.analyze_program input syntax in
          L.compile_program output_ppf code;
          Format.pp_print_newline output_ppf ()
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

let input  = Options.source_file 0 "The input file to compile."
let output = Options.target_file "The output file name."

let cmd =
  let name = "dry-compile" in
  let version = Version.string in
  let doc = "compile a DRY program" in
  let exits = Term.default_exits in
  let envs = [] in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1), $(b,dry-export)(1)" ]
  in
  Term.(const main $ Options.package_root $ input $ output $ Options.output_language $ Options.common),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
