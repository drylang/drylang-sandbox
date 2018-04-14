(* This is free and unencumbered software released into the public domain. *)

open Dry.Core

module Datum = Dry.Core.Datum

module Node = struct
  type t =
    | Const of Datum.t
    | Call of t * t list

  let rec to_string = function
    | Const datum ->
      Printf.sprintf "(#const %s)" (Datum.to_string datum)
    | Call (func, args) ->
      Printf.sprintf "(#call %s %s)" (to_string func)
        (String.concat " " (List.map to_string args))
end

let rec analyze = function
  | Syntax.Node.Atom datum ->
    Node.Const datum (* TODO *)
  | Syntax.Node.List (hd :: tl) -> begin
    let hd = analyze hd in
    let tl = List.map analyze tl in
    Node.Call (hd, tl)
    end
  | _ -> Syntax.semantic_error "invalid expression"
