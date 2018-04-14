(* This is free and unencumbered software released into the public domain. *)

open Dry.Core

module Syntax = Cli.Syntax
module Expr = Cli.Syntax.Expression

(* Cli.Version *)

module Version = Cli.Version

let () = assert (String.length Version.string > 0)

(* Cli.Token *)

module Token = Cli.Token

let () = assert (Token.EOF = Token.EOF)

let () = assert (Token.INTEGER 42 = Token.INTEGER 42)

let () = assert (Token.FLOAT 1.23 = Token.FLOAT 1.23)

let () = assert (Token.SYMBOL "foobar" = Token.SYMBOL "foobar")

let () = assert (Token.LPAREN = Token.LPAREN)

let () = assert (Token.RPAREN = Token.RPAREN)

(* Cli.Lexer *)

module Lexer = Cli.Lexer

let () = assert (Lexer.lex_from_string "" = Token.EOF)

let () = assert (Lexer.lex_from_string ";\n" = Token.EOF)

let () = assert (Lexer.lex_from_string "42" = Token.INTEGER 42)

let () = assert (Lexer.lex_from_string "1.23" = Token.FLOAT 1.23)

let () = assert (Lexer.lex_from_string "foobar" = Token.SYMBOL "foobar")

let () = assert (Lexer.lex_from_string "(" = Token.LPAREN)

let () = assert (Lexer.lex_from_string ")" = Token.RPAREN)

let () = assert (Lexer.tokenize "" = [])

let () = assert (Lexer.tokenize ";\nabc" = [Token.SYMBOL "abc"])

let () = assert (Lexer.tokenize "42" = [Token.INTEGER 42])

let () = assert (Lexer.tokenize "42 kg" = [Token.INTEGER 42; Token.SYMBOL "kg"])

let () = assert (Lexer.tokenize "()" = [Token.LPAREN; Token.RPAREN])

let () = assert (Lexer.tokenize "(42)" = [Token.LPAREN; Token.INTEGER 42; Token.RPAREN])

(* Cli.Grammar *)

module Grammar = Cli.Grammar

(* Cli.Parser *)

module Parser = Cli.Parser

let one       = Syntax.Node.of_int 1
let two       = Syntax.Node.of_int 2
let three     = Syntax.Node.of_int 3
let forty_two = Syntax.Node.of_int 42

let () = assert (Parser.parse_from_string "" = None)

let () = assert (Parser.parse_from_string "foo" = Some (Syntax.Node.Atom (Datum.Symbol "foo")))

let () = assert (Parser.parse_from_string "42" = Some forty_two)

let () = assert (Parser.parse_from_string "1.23" = Some (Syntax.Node.of_float 1.23))

let () = assert (Parser.parse_from_string "()" = Some (Syntax.Node.List []))

let () = assert (Parser.parse_from_string "(42)" = Some (Syntax.Node.List [forty_two]))

let () = assert (Parser.parse_from_string "((42))" = Some (Syntax.Node.List [Syntax.Node.List [forty_two]]))

let () = assert (Parser.parse_from_string "(1 2 3)" = Some (Syntax.Node.List [one; two; three]))

let () = assert (Parser.parse_from_string "(1 (2) 3)" = Some (Syntax.Node.List [one; (Syntax.Node.List [two]); three]))

(* Cli.Syntax *)
