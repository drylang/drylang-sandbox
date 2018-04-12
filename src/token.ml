(* This is free and unencumbered software released into the public domain. *)

type t =
  | EOF
  | FLOAT of float
  | INTEGER of int
  | SYMBOL of string

type token = t

exception EOF = End_of_file
