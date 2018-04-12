(* This is free and unencumbered software released into the public domain. *)

open Dry.Core

module Syntax = Cli.Syntax
module Expr = Cli.Syntax.Expression

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

let () = assert ((Lexer.tokenize "") = [])

let () = assert ((Lexer.tokenize "42") = [Token.INTEGER 42])

let () = assert ((Lexer.tokenize "42 kg") = [Token.INTEGER 42; Token.SYMBOL "kg"])

(* Cli.Grammar *)

module Parser = Cli.Grammar

(* Cli.Parser *)

module Parser = Cli.Parser

let () = assert ((Parser.parse_from_string "foo") = (Expr.Atom (Datum.Symbol "foo")))

let () = assert ((Parser.parse_from_string "42") = (Expr.Atom (Datum.of_int 42)))

let () = assert ((Parser.parse_from_string "1.23") = (Expr.Atom (Datum.of_float 1.23)))

(* Cli.Syntax *)
