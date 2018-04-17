(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Cli

let main () =
  let lexbuf = Lexing.from_channel stdin in
  while true do
    try
      match Parser.parse_from_lexbuf lexbuf with
      | None -> exit 0
      | Some syntax -> begin
          let code = Semantic.analyze syntax in
          let buffer = Buffer.create 16 in
          Target.Lua.compile code buffer;
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

let () = main ()
