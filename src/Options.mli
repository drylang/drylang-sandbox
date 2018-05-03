(* This is free and unencumbered software released into the public domain. *)

module Verbosity : sig
  type t = Normal | Quiet | Verbose

  val to_string : t -> string
end

module OptimizationLevel : sig
  type t = None | Low | Medium | High

  val from_int : int -> t

  val to_int : t -> int
  val to_string : t -> string
end

module Common : sig
  type t =
    { debug: bool;
      verbosity: Verbosity.t; }
end

module Output : sig
  type t =
    { optimization: OptimizationLevel.t; }
end

val common : Common.t Cmdliner.Term.t
val output : Output.t Cmdliner.Term.t

val package_root : string Cmdliner.Term.t

val required_term : int -> string -> string Cmdliner.Term.t
val optional_term : int -> string -> string option Cmdliner.Term.t

val input_file : int -> string -> string option Cmdliner.Term.t
val output_file : string Cmdliner.Term.t
val output_language : string option Cmdliner.Term.t

val source_file : int -> string -> SourceFile.t Cmdliner.Term.t
val target_file : string -> TargetFile.t Cmdliner.Term.t
