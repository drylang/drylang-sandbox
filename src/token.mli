(* This is free and unencumbered software released into the public domain. *)

(** Lexer tokens. **)

type t =
  | EOF
  | FLOAT of float
  | INTEGER of int
  | STRING of string
  | SYMBOL of string
  | LPAREN
  | RPAREN

type token = t

exception EOF
