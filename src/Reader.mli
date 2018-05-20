(* This is free and unencumbered software released into the public domain. *)

(** The reader. *)

val read_datum_from_lexbuf : Lexing.lexbuf -> Semantic.Node.t option
val read_datum_from_channel : in_channel -> Semantic.Node.t option
val read_datum : string -> Semantic.Node.t option

val read_expression_from_lexbuf : Lexing.lexbuf -> Semantic.Node.t option
val read_expression_from_channel : in_channel -> Semantic.Node.t option
val read_expression : string -> Semantic.Node.t option

val read_expressions_from_lexbuf : Lexing.lexbuf -> Semantic.Node.t list
val read_expressions_from_channel : in_channel -> Semantic.Node.t list
val read_expressions : string -> Semantic.Node.t list

val read_module_from_lexbuf : ?name:string -> Lexing.lexbuf -> Module.t option
val read_module_from_channel : ?name:string -> in_channel -> Module.t option
val read_module : ?name:string -> string -> Module.t option

val read_program_from_lexbuf : Lexing.lexbuf -> Program.t option
val read_program_from_channel : in_channel -> Program.t option
val read_program : string -> Program.t option

val read_script_from_lexbuf : Lexing.lexbuf -> Program.t option
val read_script_from_channel : in_channel -> Program.t option
val read_script : string -> Program.t option
