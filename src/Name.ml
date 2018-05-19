(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Symbol = DRY.Core.Symbol

type t = Symbol.t * Symbol.t list

let make ?(package = "dry") str =
  Symbol.of_string package, List.map Symbol.of_string (String.split_on_char '/' str)

let of_string str = make str

let to_string (pkg, name) =
  (Symbol.to_string pkg) ^ ":" ^ (String.concat "/" (List.map Symbol.to_string name))
