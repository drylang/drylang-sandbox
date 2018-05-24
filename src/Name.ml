(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open DRY.Text

type t = string * string list

let is_valid str =
  not (UTF8.String.starts_with_char str '/') &&
  not (UTF8.String.ends_with_char str '/')   &&
  not (UTF8.String.contains_string str "//")

let make ?(package = "dry") str =
  match is_valid str with
  | true -> package, (String.split_on_char '/' str)
  | false -> Syntax.semantic_error "invalid name"

let of_string str =
  make str (* TODO: parse package name *)

let to_string (pkg, name) =
  pkg ^ ":" ^ (String.concat "/" name)

let package (pkg, name) = pkg

let dirname ?(sep = "/") (pkg, name) =
  List.rev name |> List.tl |> List.rev |> String.concat sep

let basename (pkg, name) =
  let rec last = function
    | [] -> assert false
    | [s] -> s
    | _ :: tl -> last tl
  in
  last name
