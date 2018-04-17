(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Datum  = DRY.Core.Datum
module Symbol = DRY.Core.Symbol

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

  let rec to_string = function
    | Const d ->
      Printf.sprintf "(%s %s)" "#const" (Datum.to_string d)

    | Var s ->
      Printf.sprintf "(%s %s)" "#var" (Symbol.to_string s)

    | Apply (f, args) ->
      Printf.sprintf "(%s %s %s)" "#apply" (to_string f)
        (String.concat " " (List.map to_string args))

    | Not a ->
      Printf.sprintf "(%s %s)" "#not" (to_string a)

    | And (a, b) ->
      Printf.sprintf "(%s %s %s)" "#and" (to_string a) (to_string b)

    | Or (a, b) ->
      Printf.sprintf "(%s %s %s)" "#or" (to_string a) (to_string b)

    | If (p, c, a) ->
      Printf.sprintf "(%s %s %s %s)" "#if" (to_string p) (to_string c) (to_string a)

    | Add (a, b) ->
      Printf.sprintf "(%s %s %s)" "#add" (to_string a) (to_string b)

    | Sub (a, b) ->
      Printf.sprintf "(%s %s %s)" "#sub" (to_string a) (to_string b)

    | Mul (a, b) ->
      Printf.sprintf "(%s %s %s)" "#mul" (to_string a) (to_string b)

    | Div (a, b) ->
      Printf.sprintf "(%s %s %s)" "#div" (to_string a) (to_string b)
end

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
    Node.Var symbol

  | Syntax.Node.Atom datum ->
    Node.Const datum

  | Syntax.Node.List (hd :: tl) ->
    analyze_operation (analyze hd) (List.map analyze tl)

  | Syntax.Node.List [] ->
    Syntax.semantic_error "invalid expression"
