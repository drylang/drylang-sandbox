(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

module Stdlib = DRY__Stdlib
module Format = Stdlib.Format

let main (input : SourceFile.t) root warnings options =
  let lexbuf = Lexing.from_channel input.channel in
  try
    match Reader.read_script_from_lexbuf lexbuf with
    | None -> Stdlib.exit 0
    | Some script ->
      begin match Evaluator.eval_script script with
      | Tensor (Scalar (Number (Int z))) ->
        Stdlib.exit (Int.to_int8 z)
      | _ -> failwith "invalid script result"
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

(* Command-line interface *)

open Cmdliner

let cmd =
  let name = "dry-evaluate" in
  let version = Version.string in
  let doc = "evaluate DRY code" in
  let exits = Term.default_exits in
  let envs = [] in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1), $(b,dry-execute)(1), $(b,dry-shell)(1)" ]
  in
  let input = Options.source_file 0 "The input file to evaluate." in
  Term.(const main $ input $ Options.package_root $ Options.warning_level $ Options.common),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
