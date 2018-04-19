(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Location   = DRY.Code.DRY.Location
module Expression = DRY.Code.DRY.Expression

module Node = Expression

(*
module LocatedNode = struct
  type t = { expr: Node.t; source: Location.t }

  let create_with_source expr source =
    { expr = expr; source = source }

  let create expr =
    create_with_source expr { line = 0; column = 0 }

  let create_with_pos expr line column =
    create_with_source expr { line = line; column = column }

  let create_with_lexpos expr (lexpos : Lexing.position) =
    let lnum = lexpos.pos_lnum in
    let cnum = (lexpos.pos_cnum - lexpos.pos_bol) + 1 in
    create_with_source expr { line = lnum; column = cnum }
end
*)

module Context = struct
  type t =
    { source_file: string;
      source_package: string;
      source_module: string;
      source_term: string; }

  let create sf sm st =
    { source_file = sf;
      source_package = "drylib";
      source_module = sm;
      source_term = st; }
end

module Error = struct
  type t = Lexical | Syntactic | Semantic
end

exception Error of Error.t * string

let lexical_error message =
  raise (Error (Lexical, message))

let syntactic_error message =
  raise (Error (Syntactic, message))

let semantic_error message =
  raise (Error (Semantic, message))
