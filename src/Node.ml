(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Format

module Datum   = DRY.Core.Datum
module Symbol  = DRY.Core.Symbol
module Comment = DRY.Code.DRY.Comment

type t =
  | Const of Datum.t
  | Id of Symbol.t
  | Name of Name.t
  | Import of Name.t list
  | Export of Name.t list
  | Apply of t * t list
  | MathNeg of t
  | MathAdd of t * t
  | MathSub of t * t
  | MathMul of t * t
  | MathDiv of t * t
  | LogicNot of t
  | LogicAnd of t * t
  | LogicOr of t * t
  | If of t * t * t
  | Loop of t list

let rec print ppf = function
  | Const d ->
    pp_print_char ppf '(';
    pp_print_char ppf '#';
    pp_print_string ppf "const";
    pp_print_char ppf ' ';
    pp_print_string ppf (Datum.to_string d);
    pp_print_char ppf ')'
  | Id s ->
    pp_print_char ppf '(';
    pp_print_char ppf '#';
    pp_print_string ppf "id";
    pp_print_char ppf ' ';
    pp_print_string ppf (Symbol.to_string s);
    pp_print_char ppf ')'
  | Name name ->
    pp_print_char ppf '(';
    pp_print_char ppf '#';
    pp_print_string ppf "name";
    pp_print_char ppf ' ';
    pp_print_string ppf (Name.to_string name);
    pp_print_char ppf ')'
  | Import names ->
    pp_print_char ppf '(';
    pp_print_char ppf '#';
    pp_print_string ppf "import";
    pp_print_char ppf ' ';
    pp_print_list ~pp_sep:pp_print_space pp_print_string ppf (List.map Name.to_string names);
    pp_print_char ppf ')'
  | Export names ->
    pp_print_char ppf '(';
    pp_print_char ppf '#';
    pp_print_string ppf "import";
    pp_print_char ppf ' ';
    pp_print_list~pp_sep:pp_print_space pp_print_string ppf (List.map Name.to_string names);
    pp_print_char ppf ')'
  | Apply (f, args) -> pp_opn ppf "apply" (f :: args)
  | MathNeg a -> pp_op1 ppf "neg" a
  | MathAdd (a, b) -> pp_op2 ppf "add" a b
  | MathSub (a, b) -> pp_op2 ppf "sub" a b
  | MathMul (a, b) -> pp_op2 ppf "mul" a b
  | MathDiv (a, b) -> pp_op2 ppf "div" a b
  | LogicNot a -> pp_op1 ppf "not" a
  | LogicAnd (a, b) -> pp_op2 ppf "and" a b
  | LogicOr (a, b) -> pp_op2 ppf "or" a b
  | If (a, b, c) -> pp_op3 ppf "if" a b c
  | Loop body -> pp_opn ppf "loop" body

and pp_op1 ppf op a =
  pp_print_char ppf '(';
  pp_print_char ppf '#';
  pp_print_string ppf op;
  pp_print_space ppf ();
  print ppf a;
  pp_print_char ppf ')'

and pp_op2 ppf op a b =
  pp_print_char ppf '(';
  pp_print_char ppf '#';
  pp_print_string ppf op;
  pp_print_space ppf ();
  print ppf a;
  pp_print_space ppf ();
  print ppf b;
  pp_print_char ppf ')'

and pp_op3 ppf op a b c =
  pp_print_char ppf '(';
  pp_print_char ppf '#';
  pp_print_string ppf op;
  pp_print_space ppf ();
  print ppf a;
  pp_print_space ppf ();
  print ppf b;
  pp_print_space ppf ();
  print ppf c;
  pp_print_char ppf ')'

and pp_opn ppf op args =
  pp_print_char ppf '(';
  pp_print_char ppf '#';
  pp_print_string ppf op;
  pp_print_space ppf ();
  pp_print_list ~pp_sep:pp_print_space print ppf args;
  pp_print_char ppf ')'

let to_string node =
  let buffer = Buffer.create 16 in
  let ppf = Format.formatter_of_buffer buffer in
  Format.pp_open_hbox ppf ();
  print ppf node;
  Format.pp_close_box ppf ();
  Format.pp_print_flush ppf ();
  Buffer.contents buffer
