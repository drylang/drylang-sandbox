(* This is free and unencumbered software released into the public domain. *)

let () = assert (Cli.Version.string = "0.0.0")

(* Cli.Token *)

module Token = Cli.Token

(* Cli.Syntax *)

module Syntax = Cli.Syntax

let () = assert ((Syntax.parse_from_string "") = Token.EOF)

let () = assert ((Syntax.parse_from_string "42") = Token.INTEGER 42)

let () = assert ((Syntax.parse_from_string "1.23") = Token.FLOAT 1.23)

let () = assert ((Syntax.parse_from_string "foobar") = Token.SYMBOL "foobar")

let () = assert ((Syntax.tokenize "") = [])

let () = assert ((Syntax.tokenize "42") = [Token.INTEGER 42])

let () = assert ((Syntax.tokenize "42 kg") = [Token.INTEGER 42; Token.SYMBOL "kg"])
