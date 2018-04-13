(* This is free and unencumbered software released into the public domain. *)

module Source = struct
  type t = { line: int; column: int }

  let record line column = { line = line; column = column }

  let unknown = { line = 0; column = 0 }
end

module Expression = Dry.Code.DRY.Expression

module Node = struct
  type t = { expr: Expression.t; source: Source.t }

  let create_with_source expr source =
    { expr = expr; source = source }

  let create expr =
    create_with_source expr Source.unknown

  let create_with_pos expr line column =
    create_with_source expr { line = line; column = column }

  let create_with_lexpos expr (lexpos : Lexing.position) =
    let lnum = lexpos.pos_lnum in
    let cnum = (lexpos.pos_cnum - lexpos.pos_bol) + 1 in
    create_with_source expr { line = lnum; column = cnum }
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
