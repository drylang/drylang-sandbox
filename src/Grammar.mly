(* This is free and unencumbered software released into the public domain. *)

%token <string> COMPLEX
%token <string> FLOAT
%token <string> INTEGER
%token <string> PERCENT
%token <string> RATIONAL
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
  | number              { Node.Literal (Datum.Tensor (Tensor.Scalar (Scalar.Number $1))) }
  | string              { Node.Literal (Datum.String $1) }
  | symbol              { Node.Id $1 }

number:
  | COMPLEX             { match Complex.parse $1 with Ok c -> Number.Complex c | _ -> assert false }
  | FLOAT               { Number.of_float (float_of_string $1) }
  | INTEGER             { Number.of_int (int_of_string $1) }
  | PERCENT             { Number.of_float (Scanf.sscanf $1 "%f" (fun r -> r /. 100.0)) }
  | RATIONAL            { match Rational.parse $1 with Ok q -> Number.Rational q | _ -> assert false }

string:
  | STRING              { $1 }

symbol:
  | SYMBOL              { Symbol.of_string $1 }
