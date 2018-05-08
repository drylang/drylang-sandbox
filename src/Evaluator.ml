(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Semantic

module Datum = DRY.Core.Datum
module Int8  = DRY.Core.Int8

(* Expressions *)

let rec eval_expression expr =
  match expr with
  | Node.Const datum -> datum
  | _ -> Datum.of_int (-1) (* TODO *)

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
