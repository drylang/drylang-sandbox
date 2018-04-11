(* This is free and unencumbered software released into the public domain. *)

(* Cli.Version *)

module Version = Cli.Version

let () = assert ((String.length Version.string) > 0)

(* Cli.Token *)

module Token = Cli.Token

let () = assert (Token.EOF = Token.EOF)

let () = assert ((Token.INTEGER 42) = (Token.INTEGER 42))

let () = assert ((Token.FLOAT 1.23) = (Token.FLOAT 1.23))

let () = assert ((Token.SYMBOL "foobar") = (Token.SYMBOL "foobar"))

(* Cli.Lexer *)

module Lexer = Cli.Lexer

let () = assert ((Lexer.lex_from_string "") = Token.EOF)

let () = assert ((Lexer.lex_from_string "42") = Token.INTEGER 42)

let () = assert ((Lexer.lex_from_string "1.23") = Token.FLOAT 1.23)

let () = assert ((Lexer.lex_from_string "foobar") = Token.SYMBOL "foobar")

(* Cli.Parser *)

module Parser = Cli.Parser

(* Cli.Syntax *)

module Syntax = Cli.Syntax

let () = assert ((Syntax.tokenize "") = [])

let () = assert ((Syntax.tokenize "42") = [Token.INTEGER 42])

let () = assert ((Syntax.tokenize "42 kg") = [Token.INTEGER 42; Token.SYMBOL "kg"])
