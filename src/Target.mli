(* This is free and unencumbered software released into the public domain. *)

module type Language = sig
  val compile_expr : Semantic.Node.t -> string
  val compile : Semantic.Node.t -> Buffer.t -> unit
  val compile_module : Semantic.Module.t -> Buffer.t -> unit
end

val by_name : string -> (module Language) option

val by_extension : string -> (module Language) option

val is_supported : string -> bool

val get : string -> (module Language)
