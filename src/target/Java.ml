(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Source = Semantic
module Target = DRY.Code.Java

let not_implemented () = failwith "not implemented yet"

let word = function
  | Word.Word8 _ -> not_implemented ()
  | Word.Word16 _ -> not_implemented ()
  | Word.Word32 _ -> not_implemented ()
  | Word.Word64 _ -> not_implemented ()

let number = function
  | Number.Float (Float32 r) -> Target.float r
  | Number.Float (Float64 r) -> Target.double r
  | Number.Int (Int8 z) -> Target.byte z
  | Number.Int (Int16 z) -> Target.short z
  | Number.Int (Int32 z) -> Target.int z
  | Number.Int (Int64 z) -> Target.long z
  | Number.Int (Int128 _) -> not_implemented ()
  | _ -> not_implemented ()

let scalar = function
  | Scalar.Bool b -> Target.boolean b
  | Scalar.Char c -> Target.char c
  | Scalar.Number n -> number n
  | Scalar.Word w -> word w

let tensor = function
  | Tensor.Scalar x -> scalar x
  | Tensor.Vector _ -> not_implemented ()
  | Tensor.Matrix _ -> not_implemented ()

let datum = function
  | Datum.Symbol _ -> not_implemented ()
  | Datum.Tensor x -> tensor x
  | _ -> not_implemented ()

let rec translate_node = function
  | Source.Node.Const x -> datum x
  | _ -> not_implemented ()

let translate_module (module_ : Source.Module.t) =
  let modifiers  = [Target.ClassModifier.Public; Target.ClassModifier.Final] in
  let imports    = [Target.ImportDecl.Normal "dry.*"] in
  let extends    = Target.Identifier.of_string "java.lang.Object" in
  let implements = [] in
  let class_decl = Target.ClassDecl.create (Symbol.to_string module_.name) ~modifiers ~extends ~implements in
  let class_def  = Target.TypeDecl.Class class_decl in
  Target.CompilationUnit.create ~imports class_def

let translate_program (program : Source.Program.t) =
  let modifiers  = [Target.ClassModifier.Public; Target.ClassModifier.Final] in
  let imports    = [Target.ImportDecl.Normal "dry.*"] in
  let extends    = Target.Identifier.of_string "java.lang.Object" in
  let implements = [] in
  let class_decl = Target.ClassDecl.create "main" ~modifiers ~extends ~implements in
  let class_def  = Target.TypeDecl.Class class_decl in
  Target.CompilationUnit.create ~imports class_def

let compile_node ppf node =
  translate_node node |> Target.print ppf

let compile_module ppf module_ =
  let output = translate_module module_ in
  Target.CompilationUnit.print ppf output

let compile_program ppf program =
  let output = translate_program program in
  Target.CompilationUnit.print ppf output
