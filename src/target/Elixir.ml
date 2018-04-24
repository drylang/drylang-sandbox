(* This is free and unencumbered software released into the public domain. *)

module Source = Semantic
module Target = DRY.Code.Lua (* TODO *)

let not_implemented () = failwith "not implemented yet"

let word = function
  | Word.Word8 _ -> not_implemented ()
  | Word.Word16 _ -> not_implemented ()
  | Word.Word32 _ -> not_implemented ()
  | Word.Word64 _ -> not_implemented ()

let number = function
  | Number.Float _ -> not_implemented ()
  | Number.Int _ -> not_implemented ()
  | _ -> not_implemented ()

let scalar = function
  | Scalar.Bool _ -> not_implemented ()
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

let compile_node ppf = function
  | Source.Node.Const x -> Target.print ppf (datum x)
  | _ -> not_implemented ()

let compile_module ppf code =
  not_implemented ()

let compile_program ppf code =
  not_implemented ()
