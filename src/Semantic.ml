(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Datum   = DRY.Core.Datum
module Symbol  = DRY.Core.Symbol
module Comment = DRY.Code.DRY.Comment

let not_implemented () = failwith "not implemented yet"

module Node = struct
  open Format

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
end

let analyze_identifier symbol =
  match Symbol.to_string symbol with
  | "true" -> Node.Const (Datum.of_bool true)
  | "false" -> Node.Const (Datum.of_bool false)
  | "/" -> Node.Id symbol
  | s ->
    begin match String.contains s '/' with
    | false -> Node.Id symbol
    | true  -> Node.Name (Name.of_string s)
    end

let analyze_name = function
  | Node.Name name -> name
  | _ -> Syntax.semantic_error "invalid name"

let analyze_operation operator operands =
  match operator with
  | Node.Id symbol -> begin
      match (Symbol.to_string symbol, operands) with
      | "neg", a :: [] -> Node.MathNeg a
      | "+",   a :: b :: [] -> Node.MathAdd (a, b)
      | "-",   a :: b :: [] -> Node.MathSub (a, b)
      | "*",   a :: b :: [] -> Node.MathMul (a, b)
      | "/",   a :: b :: [] -> Node.MathDiv (a, b)
      | "not", a :: [] -> Node.LogicNot a
      | "and", a :: b :: [] -> Node.LogicAnd (a, b)
      | "or",  a :: b :: [] -> Node.LogicOr (a, b)
      | "if",  a :: b :: c :: [] -> Node.If (a, b, c)
      | "loop", _ -> Node.Loop operands
      | "import", _ -> Node.Import (List.map analyze_name operands)
      | "export", _ -> Node.Export (List.map analyze_name operands)
      | _, _ -> Node.Apply (operator, operands)
    end
  | Node.Name name -> Node.Apply (operator, operands)
  | _ -> Syntax.semantic_error "invalid operation"

let rec analyze_node = function
  | Syntax.Node.Atom (Datum.Symbol symbol) ->
    analyze_identifier symbol

  | Syntax.Node.Atom datum ->
    Node.Const datum

  | Syntax.Node.List (hd :: tl) ->
    analyze_operation (analyze_node hd) (List.map analyze_node tl)

  | Syntax.Node.List [] ->
    Syntax.semantic_error "invalid expression"
