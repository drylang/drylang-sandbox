(* This is free and unencumbered software released into the public domain. *)

%token <string> CHAR
%token <string> COMPLEX FLOAT INTEGER PERCENT RATIONAL
%token <string> STRING SYMBOL URI UUID
%token <string> WORD_BIN WORD_OCT WORD_HEX
%token EOF LPAREN RPAREN QUOTE BACKQUOTE

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
  | QUOTE quoted_atom   { $2 }
  | atom                { $1 }

exprs:
  |                     { [] }
  | expr exprs          { $1 :: $2 }

quoted_atom:
  | symbol              { Node.Literal (Datum.Symbol $1) }

atom:
  | char                { Node.Literal (Datum.Tensor (Tensor.Scalar (Scalar.Char $1))) }
  | number              { Node.Literal (Datum.Tensor (Tensor.Scalar (Scalar.Number $1))) }
  | string              { Node.Literal (Datum.String $1) }
  | symbol              { Node.Id $1 }
  | uri                 { Node.Literal (Datum.String $1) } (* FIXME *)
  | uuid                { Node.Literal (Datum.String $1) } (* FIXME *)
  | word                { Node.Literal (Datum.Tensor (Tensor.Scalar (Scalar.Word $1))) }

char:
  | CHAR                { Scanf.sscanf $1 "%x" Uchar.of_int }

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

uri:
  | URI                 { $1 }

uuid:
  | UUID                { $1 }

word:
  | WORD_BIN            { match Word.parse_bin $1 with Ok w -> w | _ -> assert false }
  | WORD_OCT            { match Word.parse_oct $1 with Ok w -> w | _ -> assert false }
  | WORD_HEX            { match Word.parse_hex $1 with Ok w -> w | _ -> assert false }
