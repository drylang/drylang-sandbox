(* This is free and unencumbered software released into the public domain. *)

(** Lexer tokens. **)

type t =
  | EOF
  | FLOAT of float
  | INTEGER of int
  | SYMBOL of string

type token = t

exception EOF
