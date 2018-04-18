(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

let main input =
  let input_channel =
    match input with
    | None | Some "-" -> stdin
    | Some s -> open_in s
  in
  let lexbuf = Lexing.from_channel input_channel in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some syntax -> Printf.printf "%s\n%!" (Syntax.Node.to_string syntax)
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
  let doc = "The input file to parse." in
  Arg.(value & pos 0 (some non_dir_file) None & info [] ~docv:"INPUT" ~doc)

let cmd =
  let name = "dry-parse" in
  let version = Version.string in
  let doc = "parse DRY code" in
  let exits = Term.default_exits in
  let envs = [] in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1), $(b,dry-analyze)(1)" ]
  in
  Term.(const main $ input),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
