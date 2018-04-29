(* This is free and unencumbered software released into the public domain. *)

module PackageRoot : sig
  val term : string Cmdliner.Term.t
end

module Verbosity : sig
  type t = Normal | Quiet | Verbose

  val to_string : t -> string
end

type t =
  { debug: bool;
    verbosity: Verbosity.t; }

val term : t Cmdliner.Term.t
