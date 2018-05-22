(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

type t =
  | EOF
  | COMPLEX of string
  | FLOAT of string
  | INTEGER of string
  | PERCENT of string
  | RATIONAL of string
  | STRING of string
  | SYMBOL of string
  | LPAREN
  | RPAREN

type token = t

exception EOF = End_of_file
