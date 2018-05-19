(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open DRY.Text

module Symbol = DRY.Core.Symbol

type t = Symbol.t * Symbol.t list

let is_valid str =
  not (UTF8.String.starts_with_char str '/') &&
  not (UTF8.String.ends_with_char str '/')   &&
  not (UTF8.String.contains_string str "//")

let make ?(package = "dry") str =
  match is_valid str with
  | true ->
    let strs = (String.split_on_char '/' str) in
    Symbol.of_string package, List.map Symbol.of_string strs
  | false -> Syntax.semantic_error "invalid name"

let of_string str =
  make str (* TODO: parse package name *)

let to_string (pkg, name) =
  (Symbol.to_string pkg) ^ ":" ^ (String.concat "/" (List.map Symbol.to_string name))
