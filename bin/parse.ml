(* This is free and unencumbered software released into the public domain. *)

open Dry.Core
open Cli

let main () =
  let lexbuf = Lexing.from_channel stdin in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some node -> Printf.printf "%s\n%!" (Syntax.Node.to_string node)
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

let () = main ()
