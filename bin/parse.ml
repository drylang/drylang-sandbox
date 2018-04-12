(* This is free and unencumbered software released into the public domain. *)

open Dry.Core
open Cli

let main () =
  let lexbuf = Lexing.from_channel stdin in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some (Atom datum) ->
        print_endline (Datum.to_string datum)
      | Some _ ->
        print_newline () (* TODO *)
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
