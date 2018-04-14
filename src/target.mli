(* This is free and unencumbered software released into the public domain. *)

module type Language = sig
  val compile : Semantic.Node.t -> Buffer.t -> unit
end

(** C *)
module C : Language

(** C++ *)
module Cpp : Language

(** D *)
module D : Language

(** Dart *)
module Dart : Language

(** Elixir *)
module Elixir : Language

(** Go *)
module Go : Language

(** Java *)
module Java : Language

(** Julia *)
module Julia : Language

(** JS *)
module JS : Language

(** Kotlin *)
module Kotlin : Language

(** Common Lisp *)
module Lisp : Language

(** Lua *)
module Lua : Language

(** OCaml *)
module OCaml : Language

(** PHP *)
module PHP : Language

(** Python *)
module Python : Language

(** Ruby *)
module Ruby : Language

(** Rust *)
module Rust : Language
