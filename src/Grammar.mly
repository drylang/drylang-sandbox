(* This is free and unencumbered software released into the public domain. *)

%token <float> FLOAT
%token <int> INTEGER
%token <string> STRING
%token <string> SYMBOL
%token EOF LPAREN RPAREN

%{
open DRY.Core

let syntactic_error = Syntax.syntactic_error
%}

%start <Node.t list> parse_all
%start <Node.t> parse_one

%%

parse_all:
  | EOF                 { raise Token.EOF }
  | expr exprs EOF      { $1 :: $2 }

parse_one:
  | EOF                 { raise Token.EOF }
  | expr EOF            { $1 }

expr:
  | LPAREN exprs RPAREN { Node.Apply (List.hd $2, List.tl $2) }
  | atom                { $1 }

exprs:
  |                     { [] }
  | expr exprs          { $1 :: $2 }

atom:
  | number              { Node.Literal $1 }
  | string              { Node.Literal $1 }
  | symbol              { Node.Id $1 }

number:
  | FLOAT               { Datum.of_float $1 }
  | INTEGER             { Datum.of_int $1 }

string:
  | STRING              { Datum.Symbol (Symbol.of_string $1) } (* FIXME *)

symbol:
  | SYMBOL              { Symbol.of_string $1 }
