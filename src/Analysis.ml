(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Datum   = DRY.Core.Datum
module Symbol  = DRY.Core.Symbol
module Comment = DRY.Code.DRY.Comment

let not_implemented () = failwith "not implemented yet"

let analyze_identifier symbol =
  match Symbol.to_string symbol with
  | "none" -> not_implemented () (* TODO *)
  | "true" -> Node.Literal (Datum.of_bool true)
  | "false" -> Node.Literal (Datum.of_bool false)
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
  | Node.Id symbol -> analyze_identifier symbol
  | Node.Apply (operator, operands) ->
    analyze_operation (analyze_node operator) (List.map analyze_node operands)
  | node -> node
