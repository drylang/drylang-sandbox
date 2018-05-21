(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Source = Semantic
module Target = DRY.Code.PHP

let not_implemented () = failwith "not implemented yet"

let word = function
  | Word.Word8 _ -> not_implemented ()
  | Word.Word16 _ -> not_implemented ()
  | Word.Word32 _ -> not_implemented ()
  | Word.Word64 _ -> not_implemented ()

let number = function
  | Number.Float (Float32 r) -> Target.float r
  | Number.Float (Float64 r) -> Target.float r
  | Number.Int (Int128 _) -> not_implemented ()
  | Number.Int z -> Target.integer (Int.as_int64 z)
  | _ -> not_implemented ()

let scalar = function
  | Scalar.Bool b -> Target.boolean b
  | Scalar.Char _ -> not_implemented ()
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
  | Node.Const x -> datum x
  | _ -> not_implemented ()

let translate_module (module_ : Module.t) =
  not_implemented ()

let translate_program (program : Program.t) =
  not_implemented ()

let compile_node ppf node =
  translate_node node |> Target.print ppf

let compile_module ppf module_ =
  not_implemented ()

let compile_program ppf program =
  not_implemented ()
