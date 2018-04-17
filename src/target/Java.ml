(* This is free and unencumbered software released into the public domain. *)

module Source = Semantic.Node
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

let compile_expr code =
  match code with
  | Source.Const x -> Target.to_code (datum x)
  | _ -> not_implemented ()

let compile code buffer = not_implemented ()
