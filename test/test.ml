(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

(* Drylang.Version *)

module Version = Drylang.Version

let () = assert (String.length Version.string > 0)

(* Drylang.Token *)

module Token = Drylang.Token

let () = assert (Token.EOF = Token.EOF)

let () = assert (Token.INTEGER 42 = Token.INTEGER 42)

let () = assert (Token.FLOAT 1.23 = Token.FLOAT 1.23)

let () = assert (Token.SYMBOL "foobar" = Token.SYMBOL "foobar")

let () = assert (Token.LPAREN = Token.LPAREN)

let () = assert (Token.RPAREN = Token.RPAREN)

(* Drylang.Lexer *)

module Lexer = Drylang.Lexer

let () = assert (Lexer.lex_from_string "" = Token.EOF)

let () = assert (Lexer.lex_from_string ";\n" = Token.EOF)

let () = assert (Lexer.lex_from_string "42" = Token.INTEGER 42)

let () = assert (Lexer.lex_from_string "1.23" = Token.FLOAT 1.23)

let () = assert (Lexer.lex_from_string "true" = Token.SYMBOL "true")

let () = assert (Lexer.lex_from_string "false" = Token.SYMBOL "false")

let () = assert (Lexer.lex_from_string "foobar" = Token.SYMBOL "foobar")

let () = assert (Lexer.lex_from_string "+" = Token.SYMBOL "+")

let () = assert (Lexer.lex_from_string "-" = Token.SYMBOL "-")

let () = assert (Lexer.lex_from_string "*" = Token.SYMBOL "*")

let () = assert (Lexer.lex_from_string "/" = Token.SYMBOL "/")

let () = assert (Lexer.lex_from_string "(" = Token.LPAREN)

let () = assert (Lexer.lex_from_string ")" = Token.RPAREN)

let () = assert (Lexer.tokenize "" = [])

let () = assert (Lexer.tokenize ";\nabc" = [Token.SYMBOL "abc"])

let () = assert (Lexer.tokenize "42" = [Token.INTEGER 42])

let () = assert (Lexer.tokenize "42 kg" = [Token.INTEGER 42; Token.SYMBOL "kg"])

let () = assert (Lexer.tokenize "()" = [Token.LPAREN; Token.RPAREN])

let () = assert (Lexer.tokenize "(42)" = [Token.LPAREN; Token.INTEGER 42; Token.RPAREN])

(* Drylang.Grammar *)

module Grammar = Drylang.Grammar

(* Drylang.Syntax *)

module Syntax = Drylang.Syntax

let one       = Syntax.Node.of_int 1
let two       = Syntax.Node.of_int 2
let three     = Syntax.Node.of_int 3
let forty_two = Syntax.Node.of_int 42

let pi        = Syntax.Node.of_float 3.1415

(* Drylang.Parser *)

module Parser = Drylang.Parser
module Datum  = DRY.Core.Datum

let () = assert (Parser.parse_datum_from_string "" = None)

let () = assert (Parser.parse_datum_from_string "foo" = Some (Syntax.Node.Atom (Datum.Symbol (Symbol.of_string "foo"))))

let () = assert (Parser.parse_datum_from_string "42" = Some forty_two)

let () = assert (Parser.parse_datum_from_string "1.23" = Some (Syntax.Node.of_float 1.23))

let () = assert (Parser.parse_datum_from_string "()" = Some (Syntax.Node.List []))

let () = assert (Parser.parse_datum_from_string "(42)" = Some (Syntax.Node.List [forty_two]))

let () = assert (Parser.parse_datum_from_string "((42))" = Some (Syntax.Node.List [Syntax.Node.List [forty_two]]))

let () = assert (Parser.parse_datum_from_string "(1 2 3)" = Some (Syntax.Node.List [one; two; three]))

let () = assert (Parser.parse_datum_from_string "(1 (2) 3)" = Some (Syntax.Node.List [one; (Syntax.Node.List [two]); three]))

(* Drylang.Semantic *)

module Semantic = Drylang.Semantic

let dry input =
  match Drylang.Parser.parse_datum_from_string input with
  | None -> assert false
  | Some syntax -> Drylang.Semantic.analyze_node syntax

let () = assert (Semantic.analyze_node forty_two = Semantic.Node.Const (Datum.of_int 42))

let () = assert (dry "true" = Semantic.Node.Const (Datum.of_bool true))

let () = assert (dry "false" = Semantic.Node.Const (Datum.of_bool false))

let () = assert (dry "1.23" = Semantic.Node.Const (Datum.of_float 1.23))

let () = assert (dry "42" = Semantic.Node.Const (Datum.of_int 42))

(*
let () = assert (dry "(inc 42)" = (Semantic.Node.Apply (Semantic.Node.Const (Datum.Symbol "inc"), [Semantic.Node.Const (Datum.of_int 42)])))
*)

(* Drylang.Target *)
