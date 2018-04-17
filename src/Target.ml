(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module type Language = sig
  val compile : Semantic.Node.t -> Buffer.t -> unit
end

(** C *)
module C : Language = struct
  #include "target/C.ml"
end

(** C++ *)
module Cpp : Language = struct
  #include "target/Cpp.ml"
end

(** D *)
module D : Language = struct
  #include "target/D.ml"
end

(** Dart *)
module Dart : Language = struct
  #include "target/Dart.ml"
end

(** Elixir *)
module Elixir : Language = struct
  #include "target/Elixir.ml"
end

(** Go *)
module Go : Language = struct
  #include "target/Go.ml"
end

(** Java *)
module Java : Language = struct
  #include "target/Java.ml"
end

(** Julia *)
module Julia : Language = struct
  #include "target/Julia.ml"
end

(** JS *)
module JS : Language = struct
  #include "target/JS.ml"
end

(** Kotlin *)
module Kotlin : Language = struct
  #include "target/Kotlin.ml"
end

(** Common Lisp *)
module Lisp : Language = struct
  #include "target/Lisp.ml"
end

(** Lua *)
module Lua : Language = struct
  #include "target/Lua.ml"
end

(** OCaml *)
module OCaml : Language = struct
  #include "target/OCaml.ml"
end

(** PHP *)
module PHP : Language = struct
  #include "target/PHP.ml"
end

(** Python *)
module Python : Language = struct
  #include "target/Python.ml"
end

(** Ruby *)
module Ruby : Language = struct
  #include "target/Ruby.ml"
end

(** Rust *)
module Rust : Language = struct
  #include "target/Rust.ml"
end
