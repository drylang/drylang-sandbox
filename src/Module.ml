(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Format

module Comment = DRY.Code.DRY.Comment
module Symbol  = DRY.Core.Symbol

type t =
  { name: Symbol.t;
    comment: Comment.t option;
    code: Node.t list; }

let make ?(comment = "") ~name ~code =
  { name = Symbol.of_string name;
    comment = (match comment with "" -> None | s -> Some (Comment.of_string comment));
    code = code; }

let print ppf module_ =
  pp_print_char ppf '(';
  pp_print_string ppf "#module";
  pp_print_space ppf ();
  pp_print_list ~pp_sep:pp_print_space Node.print ppf module_.code;
  pp_print_char ppf ')'

let optimize (source : SourceFile.t) (module_ : t) =
  module_ (* TODO *)
