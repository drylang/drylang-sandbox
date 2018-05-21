(* This is free and unencumbered software released into the public domain. *)

module type Language = sig
  val compile_node : Format.formatter -> Node.t -> unit
  val compile_module : Format.formatter -> Module.t -> unit
  val compile_program : Format.formatter -> Program.t -> unit
end

val by_name : string -> (module Language) option

val by_extension : string -> (module Language) option

val is_supported : string -> bool

val get : string -> (module Language)
