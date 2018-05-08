(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

let print_prompt () =
  print_string "> "; flush stdout

let read_input () =
  try Some (read_line ()) with End_of_file -> None

let main root options =
  while true do
    print_prompt ();
    match read_input () with
    | None -> print_newline(); exit 0
    | Some input -> begin
        try
          match Reader.read_expression input with
          | None -> assert false (* EOF already handled *)
          | Some code ->
            let result = Evaluator.eval_expression code in
            Printf.printf "%s\n%!" (Datum.to_string result)
        with
        | Syntax.Error (Lexical, message) ->
          Printf.eprintf "lexical error: %s\n%!" message
        | Syntax.Error (Syntactic, message) ->
          Printf.eprintf "syntax error: %s\n%!" message
        | Syntax.Error (Semantic, message) ->
          Printf.eprintf "semantic error: %s\n%!" message
      end
  done

(* Command-line interface *)

open Cmdliner

let cmd =
  let name = "dry-shell" in
  let version = Version.string in
  let doc = "the interactive DRY shell" in
  let exits = Term.default_exits in
  let envs = [] in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1), $(b,dry-evaluate)(1)" ]
  in
  Term.(const main $ Options.package_root $ Options.common),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
