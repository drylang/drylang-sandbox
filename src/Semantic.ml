(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Datum   = DRY.Core.Datum
module Symbol  = DRY.Core.Symbol
module Comment = DRY.Code.DRY.Comment

let sprintf = Printf.sprintf

let not_implemented () = failwith "not implemented yet"

module Node = struct
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

  let rec to_code = function
    | Const d -> sprintf "(%s %s)" "#const" (Datum.to_string d)

    | Var s ->
      sprintf "(%s %s)" "#var" (Symbol.to_string s)

    | Apply (f, args) ->
      sprintf "(%s %s %s)" "#apply" (to_code f)
        (String.concat " " (List.map to_code args))

    | Not a ->
      sprintf "(%s %s)" "#not" (to_code a)

    | And (a, b) ->
      sprintf "(%s %s %s)" "#and" (to_code a) (to_code b)

    | Or (a, b) ->
      sprintf "(%s %s %s)" "#or" (to_code a) (to_code b)

    | If (p, c, a) ->
      sprintf "(%s %s %s %s)" "#if" (to_code p) (to_code c) (to_code a)

    | Add (a, b) ->
      sprintf "(%s %s %s)" "#add" (to_code a) (to_code b)

    | Sub (a, b) ->
      sprintf "(%s %s %s)" "#sub" (to_code a) (to_code b)

    | Mul (a, b) ->
      sprintf "(%s %s %s)" "#mul" (to_code a) (to_code b)

    | Div (a, b) ->
      sprintf "(%s %s %s)" "#div" (to_code a) (to_code b)

  let to_string = to_code
end

module Module = struct
  type t =
    { name: Symbol.t;
      comment: Comment.t option; }

  let create ?(comment = "") ~name =
    { name = Symbol.of_string name;
      comment = (match comment with "" -> None | s -> Some (Comment.of_string comment)); }

  let to_code (mod_ : t) = ""

  let to_string = to_code
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

let rec analyze = function
  | Syntax.Node.Atom (Datum.Symbol symbol) ->
    analyze_identifier symbol

  | Syntax.Node.Atom datum ->
    Node.Const datum

  | Syntax.Node.List (hd :: tl) ->
    analyze_operation (analyze hd) (List.map analyze tl)

  | Syntax.Node.List [] ->
    Syntax.semantic_error "invalid expression"

let analyze_module (context : Syntax.Context.t) (syntax : Syntax.Node.t) =
  let module_name = context.source_module in
  let term_name = context.source_term in
  match syntax with
  | Syntax.Node.Atom datum ->
    Syntax.semantic_error "invalid module definition"
  | Syntax.Node.List (hd :: tl) ->
    Module.create term_name (* TODO *)
  | Syntax.Node.List [] ->
    Module.create term_name (* TODO *)
