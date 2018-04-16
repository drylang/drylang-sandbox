(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Datum  = DRY.Core.Datum
module Symbol = DRY.Core.Symbol

module Node = struct
  type t =
    | Const of Datum.t
    | Var of Symbol.t
    | Apply of t * t list
    | And of t * t
    | Or of t * t
    | If of t * t * t

  let rec to_string = function
    | Const datum ->
      Printf.sprintf "(#const %s)"
        (Datum.to_string datum)

    | Var symbol ->
      Printf.sprintf "(#var %s)"
        (Symbol.to_string symbol)

    | Apply (function_, arguments) ->
      Printf.sprintf "(#apply %s %s)"
        (to_string function_)
        (String.concat " " (List.map to_string arguments))

    | And (expression1, expression2) ->
      Printf.sprintf "(#and %s %s)"
        (to_string expression1)
        (to_string expression2)

    | Or (expression1, expression2) ->
      Printf.sprintf "(#or %s %s)"
        (to_string expression1)
        (to_string expression2)

    | If (predicate, consequent, alternative) ->
      Printf.sprintf "(#if %s %s %s)"
        (to_string predicate)
        (to_string consequent)
        (to_string alternative)
end

let analyze_operation operator operands =
  match operator with
  | Node.Var symbol -> begin
      match (symbol, operands) with
      | "and", lhs :: rhs :: [] -> Node.And (lhs, rhs)
      | "or", lhs :: rhs :: [] -> Node.Or (lhs, rhs)
      | "if", predicate :: consequent :: alternative :: [] ->
        Node.If (predicate, consequent, alternative)
      | _, _ -> Node.Apply (operator, operands)
    end
  | _ -> Syntax.semantic_error "invalid operation"

let rec analyze = function
  | Syntax.Node.Atom (Datum.Symbol symbol) ->
    Node.Var symbol

  | Syntax.Node.Atom datum ->
    Node.Const datum

  | Syntax.Node.List (hd :: tl) ->
    analyze_operation (analyze hd) (List.map analyze tl)

  | Syntax.Node.List [] ->
    Syntax.semantic_error "invalid expression"
