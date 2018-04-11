(* This is free and unencumbered software released into the public domain. *)

open Dry.Core
open Cli

let () =
  let print_prompt () = print_string "> "; flush stdout in
  while true do
    print_prompt ();
    let input = read_line () in
    match Syntax.parse_from_string input with
      | Atom datum -> print_endline (Datum.to_string datum)
      | _ -> print_newline() (* TODO *)
  done
