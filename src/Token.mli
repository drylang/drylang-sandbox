(* This is free and unencumbered software released into the public domain. *)

(** Lexer tokens. **)

type t =
  | EOF
  | CHAR of string
  | COMPLEX of string
  | FLOAT of string
  | INTEGER of string
  | PERCENT of string
  | RATIONAL of string
  | STRING of string
  | SYMBOL of string
  | WORD_BIN of string
  | WORD_OCT of string
  | WORD_HEX of string
  | LPAREN
  | RPAREN
  | QUOTE
  | BACKQUOTE

type token = t

exception EOF
