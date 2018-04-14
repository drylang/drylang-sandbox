(* This is free and unencumbered software released into the public domain. *)

%token <float> FLOAT
%token <int> INTEGER
%token <string> STRING
%token <string> SYMBOL
%token EOF LPAREN RPAREN

%{
open Dry.Core
open Syntax.Expression

let syntactic_error = Syntax.syntactic_error
%}

%start <Syntax.Node.t> parse

%%

parse:
  | EOF      { raise Token.EOF }
  | LPAREN RPAREN { Syntax.Node.create_with_lexpos (List []) $symbolstartpos }
  | atom EOF { Syntax.Node.create_with_lexpos $1 $symbolstartpos }

atom:
  | string { Atom $1 }
  | symbol { Atom $1 }
  | number { Atom $1 }

number:
  | float=FLOAT     { Datum.of_float float }
  | integer=INTEGER { Datum.of_int integer }

string:
  | string=STRING   { Datum.Symbol string } (* FIXME *)

symbol:
  | string=SYMBOL   { Datum.Symbol string }
