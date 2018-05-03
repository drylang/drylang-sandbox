(* This is free and unencumbered software released into the public domain. *)

module Verbosity : sig
  type t = Normal | Quiet | Verbose

  val to_string : t -> string
end

module OptimizationLevel : sig
  type t = None | Low | Medium | High

  val from_int : int -> t
  val from_string : string -> t

  val to_int : t -> int
  val to_string : t -> string
end

module WarningLevel : sig
  type t = None | Low | Medium | High

  val from_int : int -> t
  val from_string : string -> t

  val to_int : t -> int
  val to_string : t -> string
end

module CommonOptions : sig
  type t =
    { debug: bool;
      verbosity: Verbosity.t; }
end

module OutputOptions : sig
  type t =
    { optimizations: OptimizationLevel.t; }
end

module TargetOptions : sig
  type t =
    { file: TargetFile.t;
      language: string option;
      optimizations: OptimizationLevel.t;
      warnings: WarningLevel.t; }
end

val common : CommonOptions.t Cmdliner.Term.t
val output : OutputOptions.t Cmdliner.Term.t
val target : TargetOptions.t Cmdliner.Term.t

val package_root : string Cmdliner.Term.t

val required_term : int -> string -> string Cmdliner.Term.t
val optional_term : int -> string -> string option Cmdliner.Term.t

val input_file : int -> string -> string option Cmdliner.Term.t
val output_file : string Cmdliner.Term.t
val output_language : string option Cmdliner.Term.t

val source_file : int -> string -> SourceFile.t Cmdliner.Term.t
val target_file : string -> TargetFile.t Cmdliner.Term.t
