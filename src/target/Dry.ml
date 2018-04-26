(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Source = Semantic
module Target = Source

let not_implemented () = failwith "not implemented yet"

let translate_node node = node

let translate_module (module_ : Source.Module.t) =
  Target.Module.make ~name:(Symbol.to_string module_.name)
    ~code:(List.map translate_node module_.code)
    ~comment:""

let translate_program (program : Source.Program.t) =
  Target.Program.make (List.map translate_node program.code)

let compile_node ppf node =
  (* DEBUG *) Format.pp_print_char ppf ';'; Source.Node.print ppf node; Format.pp_print_newline ppf ();
  translate_node node |> Target.Node.print ppf

let compile_module ppf module_ =
  (* DEBUG *) Format.pp_print_char ppf ';'; Source.Module.print ppf module_; Format.pp_print_newline ppf ();
  translate_module module_ |> Target.Module.print ppf

let compile_program ppf program =
  (* DEBUG *) Format.pp_print_char ppf ';'; Source.Program.print ppf program; Format.pp_print_newline ppf ();
  translate_program program |> Target.Program.print ppf
