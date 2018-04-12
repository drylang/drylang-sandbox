(* This is free and unencumbered software released into the public domain. *)

module Expression = Dry.Code.DRY.Expression

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
