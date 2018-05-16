(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Semantic.Node

module Datum = DRY.Core.Datum
module Int8  = DRY.Core.Int8

let not_implemented () = failwith "not implemented yet"

(* Expressions *)

let rec eval_expression expr =
  match expr with
  | Const datum -> datum

  | LogicNot a ->
    begin match eval_expression a with
    | Tensor (Scalar (Bool a)) -> Datum.of_bool (not a)
    | _ -> failwith "expected boolean expression"
    end

  | LogicAnd (a, b) -> not_implemented () (* TODO *)

  | LogicOr (a, b) -> not_implemented () (* TODO *)

  | If (a, b, c) ->
    begin match eval_expression a with
    | Tensor (Scalar (Bool a)) ->
      eval_expression (if a then b else c)
    | _ -> failwith "expected boolean expression"
    end

  | _ -> not_implemented () (* TODO *)

(* Expressions *)

let rec eval_expressions = function
  | [] -> failwith "invalid program structure"
  | [expr] -> eval_expression expr
  | hd :: tl -> begin
      eval_expression hd |> ignore;
      eval_expressions tl
    end

(* Program *)

let eval_program (program : Semantic.Program.t) =
  eval_expressions program.code

(* Script *)

let eval_script (script : Semantic.Program.t) =
  eval_expressions script.code
