(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Drylang

let main id output =
  let lexbuf = Lexing.from_channel stdin in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some syntax ->
        begin match Target.by_extension "lua" with (* TODO *)
        | None -> exit 1
        | Some (module L : Target.Language) ->
          let code = Semantic.analyze syntax in
          let buffer = Buffer.create 16 in
          L.compile code buffer;
          Buffer.output_buffer stdout buffer;
          Printf.printf "\n%!"
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

let id =
  let doc = "The identifier to export." in
  Arg.(value & pos 0 (some string) None & info [] ~docv:"ID" ~doc)

let output =
  let doc = "The output file name." in
  Arg.(value & opt string "" & info ["o"; "output"] ~docv:"OUTPUT" ~doc)

let cmd =
  let name = "dry-export" in
  let version = Version.string in
  let doc = "export DRY code" in
  let exits = Term.default_exits in
  let envs =
    let doc = "Overrides the default package index (~/.dry)." in
    let root = Arg.env_var "DRY_ROOT" ~doc in
    [root]
  in
  let man = [
    `S Manpage.s_bugs; `P "File bug reports at <$(b,https://github.com/dryproject/drylang)>.";
    `S Manpage.s_see_also; `P "$(b,dry)(1)" ]
  in
  Term.(const main $ id $ output),
  Term.info name ~version ~doc ~exits ~envs ~man

let () = Term.(exit @@ eval cmd)
