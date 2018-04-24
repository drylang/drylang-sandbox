(* This is free and unencumbered software released into the public domain. *)

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

let compile_node ppf = function
  | Source.Node.Const x -> Target.print ppf (datum x)
  | _ -> not_implemented ()

let translate_module (code : Source.Module.t) =
  let modifiers  = [Target.ClassModifier.Public; Target.ClassModifier.Final] in
  let imports    = [Target.ImportDecl.Normal "dry.*"] in
  let extends    = Target.Identifier.of_string "java.lang.Object" in
  let implements = [] in
  let class_decl = Target.ClassDecl.create (Symbol.to_string code.name) ~modifiers ~extends ~implements in
  let class_def  = Target.TypeDecl.Class class_decl in
  Target.CompilationUnit.create ~imports class_def

let compile_module ppf code =
  let output = translate_module code in
  Target.CompilationUnit.print ppf output

let compile_program ppf code =
  not_implemented ()
