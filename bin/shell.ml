(* This is free and unencumbered software released into the public domain. *)

open Dry.Core
open Cli

let print_prompt () =
  print_string "> "; flush stdout

let read_input () =
  try Some (read_line ()) with End_of_file -> None

let main () =
  while true do
    print_prompt ();
    match read_input () with
    | None -> print_newline(); exit 0
    | Some input -> begin
        try
          match Parser.parse_from_string input with
          | None -> assert false (* EOF already handled *)
          | Some node -> Printf.printf "%s\n%!" (Syntax.Node.to_string node)
        with
        | Syntax.Error (Lexical, message) ->
          Printf.eprintf "lexical error: %s\n%!" message
        | Syntax.Error (Syntactic, message) ->
          Printf.eprintf "syntax error: %s\n%!" message
        | Syntax.Error (Semantic, message) ->
          Printf.eprintf "semantic error: %s\n%!" message
      end
  done

let () = main ()
