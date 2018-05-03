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
    | Var of Symbol.t
    | Apply of t * t list
    | Not of t
    | And of t * t
    | Or of t * t
    | If of t * t * t
    | Add of t * t
    | Sub of t * t
    | Mul of t * t
    | Div of t * t

  let rec print ppf = function
    | Const d ->
      pp_print_char ppf '(';
      pp_print_char ppf '#';
      pp_print_string ppf "const";
      pp_print_char ppf ' ';
      pp_print_string ppf (Datum.to_string d);
      pp_print_char ppf ')'
    | Var s ->
      pp_print_char ppf '(';
      pp_print_char ppf '#';
      pp_print_string ppf "var";
      pp_print_char ppf ' ';
      pp_print_string ppf (Symbol.to_string s);
      pp_print_char ppf ')'
    | Apply (f, args) -> pp_opn ppf "apply" args
    | Not a -> pp_op1 ppf "not" a
    | And (a, b) -> pp_op2 ppf "and" a b
    | Or (a, b) -> pp_op2 ppf "or" a b
    | If (a, b, c) -> pp_op3 ppf "if" a b c
    | Add (a, b) -> pp_op2 ppf "add" a b
    | Sub (a, b) -> pp_op2 ppf "sub" a b
    | Mul (a, b) -> pp_op2 ppf "mul" a b
    | Div (a, b) -> pp_op2 ppf "div" a b

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

  let to_string x = ""
end

module Module = struct
  open Format

  type t =
    { name: Symbol.t;
      comment: Comment.t option;
      code: Node.t list; }

  let make ?(comment = "") ~name ~code =
    { name = Symbol.of_string name;
      comment = (match comment with "" -> None | s -> Some (Comment.of_string comment));
      code = code; }

  let print ppf module_ =
    pp_print_char ppf '(';
    pp_print_string ppf "module";
    pp_print_space ppf ();
    pp_print_list ~pp_sep:pp_print_space Node.print ppf module_.code;
    pp_print_char ppf ')';
end

module Program = struct
  open Format

  type t =
    { code: Node.t list; }

  let make args =
    { code = args; }

  let print ppf program =
    pp_print_char ppf '(';
    pp_print_string ppf "program";
    pp_print_space ppf ();
    pp_print_list ~pp_sep:pp_print_space Node.print ppf program.code;
    pp_print_char ppf ')';
end

let analyze_identifier symbol =
  match Symbol.to_string symbol with
  | "true" -> Node.Const (Datum.of_bool true)
  | "false" -> Node.Const (Datum.of_bool false)
  | _ -> Node.Var symbol

let analyze_operation operator operands =
  match operator with
  | Node.Var symbol -> begin
      match (Symbol.to_string symbol, operands) with
      | "not", a :: [] -> Node.Not a
      | "and", a :: b :: [] -> Node.And (a, b)
      | "or", a :: b :: [] -> Node.Or (a, b)
      | "if", a :: b :: c :: [] -> Node.If (a, b, c)
      | "+", a :: b :: [] -> Node.Add (a, b)
      | "-", a :: b :: [] -> Node.Sub (a, b)
      | "*", a :: b :: [] -> Node.Mul (a, b)
      | "/", a :: b :: [] -> Node.Div (a, b)
      | _, _ -> Node.Apply (operator, operands)
    end
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

let analyze_module (source : SourceFile.t) (syntax : Syntax.Node.t) =
(*
  let _module_name = source.module_ in
*)
  let term_name = source.term in
  match syntax with
  | Syntax.Node.Atom datum ->
    Syntax.semantic_error "invalid module definition"
  | Syntax.Node.List [] ->
    Module.make term_name [] (* TODO *)
  | Syntax.Node.List code ->
    Module.make term_name (List.map analyze_node code)

let analyze_program (source : SourceFile.t) (syntax : Syntax.Node.t) =
(*
  let _module_name = source.module_ in
  let _term_name = source.term in
*)
  match syntax with
  | Syntax.Node.Atom datum ->
    Syntax.semantic_error "invalid program structure"
  | Syntax.Node.List code ->
    Program.make (List.map analyze_node code)

let optimize_node = function
  | node -> node (* TODO *)

let optimize_module (source : SourceFile.t) (module_ : Module.t) =
  module_ (* TODO *)

let optimize_program (source : SourceFile.t) (program : Program.t) =
  program (* TODO *)
