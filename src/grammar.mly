(* This is free and unencumbered software released into the public domain. *)

%token <float> FLOAT
%token <int> INTEGER
%token <string> SYMBOL
%token EOF

%{
open Dry.Core
open Syntax.Expression

let syntactic_error = Syntax.syntactic_error
%}

%start <Syntax.Expression.t> parse

%%

parse:
  | atom EOF { $1 }

atom:
  | symbol { Atom $1 }
  | number { Atom $1 }

symbol:
  | string=SYMBOL   { Datum.Symbol string }

number:
  | float=FLOAT     { Datum.of_float float }
  | integer=INTEGER { Datum.of_int integer }
