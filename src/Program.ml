(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Format

module Node = Semantic.Node

type t = { code: Node.t list; }

let make args = { code = args; }

let print ppf program =
  pp_print_char ppf '(';
  pp_print_string ppf "#program";
  pp_print_space ppf ();
  pp_print_list ~pp_sep:pp_print_space Node.print ppf program.code;
  pp_print_char ppf ')'

let optimize (source : SourceFile.t) (program : t) =
  program (* TODO *)
