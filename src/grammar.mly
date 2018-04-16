(* This is free and unencumbered software released into the public domain. *)

%token <float> FLOAT
%token <int> INTEGER
%token <string> STRING
%token <string> SYMBOL
%token EOF LPAREN RPAREN

%{
open DRY.Core
open Syntax.Expression

let syntactic_error = Syntax.syntactic_error
%}

%start <Syntax.Node.t> parse

%%

parse:
  | EOF                 { raise Token.EOF }
  | expr EOF            { $1 }

expr:
  | LPAREN exprs RPAREN { List $2 }
  | atom                { $1 }

exprs:
  |                     { [] }
  | expr exprs          { $1 :: $2 }

atom:
  | string              { Atom $1 }
  | symbol              { Atom $1 }
  | number              { Atom $1 }

number:
  | FLOAT               { Datum.of_float $1 }
  | INTEGER             { Datum.of_int $1 }

string:
  | STRING              { Datum.Symbol $1 } (* FIXME *)

symbol:
  | SYMBOL              { Datum.Symbol $1 }
