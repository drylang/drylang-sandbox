(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Source = Semantic
module Target = Source

let translate_node node = node

let translate_module (module_ : Module.t) =
  Module.make ~name:(Symbol.to_string module_.name)
    ~code:(List.map translate_node module_.code)
    ~comment:""

let translate_program (program : Program.t) =
  Program.make (List.map translate_node program.code)

let compile_node ppf node =
  translate_node node |> Target.Node.print ppf

let compile_module ppf module_ =
  translate_module module_ |> Module.print ppf

let compile_program ppf program =
  translate_program program |> Program.print ppf
