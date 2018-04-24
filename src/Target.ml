(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module type Language = sig
  val compile_expr : Semantic.Node.t -> string
  val compile : Semantic.Node.t -> Buffer.t -> unit
  val compile_module : Semantic.Module.t -> Buffer.t -> unit
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

(** Wasm *)
module Wasm : Language = struct
  #include "target/Wasm.ml"
end

let by_name = function
  | "c" -> Some (module C : Language)
  | "cpp" | "c++" -> Some (module Cpp : Language)
  | "d" -> Some (module D : Language)
  | "dart" -> Some (module Dart : Language)
  | "elixir" -> Some (module Elixir : Language)
  | "go" -> Some (module Go : Language)
  | "java" -> Some (module Java : Language)
  | "julia" -> Some (module Julia : Language)
  | "js" -> Some (module JS : Language)
  | "kotlin" -> Some (module Kotlin : Language)
  | "lisp" -> Some (module Lisp : Language)
  | "lua" -> Some (module Lua : Language)
  | "ocaml" -> Some (module OCaml : Language)
  | "php" -> Some (module PHP : Language)
  | "python" -> Some (module Python : Language)
  | "ruby" -> Some (module Ruby : Language)
  | "rust" -> Some (module Rust : Language)
  | "wast" -> Some (module Wasm : Language)
  | _ -> None

let by_extension = function
  | "c" -> Some (module C : Language)
  | "cpp" | "cc" -> Some (module Cpp : Language)
  | "d" -> Some (module D : Language)
  | "dart" -> Some (module Dart : Language)
  | "ex" -> Some (module Elixir : Language)
  | "go" -> Some (module Go : Language)
  | "java" -> Some (module Java : Language)
  | "jl" -> Some (module Julia : Language)
  | "js" -> Some (module JS : Language)
  | "kt" -> Some (module Kotlin : Language)
  | "lisp" -> Some (module Lisp : Language)
  | "lua" -> Some (module Lua : Language)
  | "ml" -> Some (module OCaml : Language)
  | "php" -> Some (module PHP : Language)
  | "py" -> Some (module Python : Language)
  | "rb" -> Some (module Ruby : Language)
  | "rs" -> Some (module Rust : Language)
  | "wast" | "wat" -> Some (module Wasm : Language)
  | _ -> None

let is_supported ext =
  match by_extension ext with
  | None -> false | Some _ -> true

let get name =
  match by_name name with
  | None -> assert false
  | Some language -> language
