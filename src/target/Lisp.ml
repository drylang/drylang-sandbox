(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Source = Node
module Target = DRY.Code.Lisp

let not_implemented () = failwith "not implemented yet"

let symbol s = Target.symbol (Symbol.of_string s)

let word = function
  | Word.Word8 w  -> Target.form [symbol "dry:word8"; Target.number (Number.of_int64 (Word8.as_int64 w))]
  | Word.Word16 w -> Target.form [symbol "dry:word16"; Target.number (Number.of_int64 (Word16.as_int64 w))]
  | Word.Word32 w -> Target.form [symbol "dry:word32"; Target.number (Number.of_int64 (Word32.as_int64 w))]
  | Word.Word64 w -> Target.form [symbol "dry:word64"; Target.number (Number.of_int64 (Word64.as_int64 w))]

let number = Target.number

let scalar = function
  | Scalar.Bit b -> Target.of_int (Bit.to_int b)
  | Scalar.Bool b -> Target.Object.of_bool b
  | Scalar.Char c -> Target.character c
  | Scalar.Number n -> number n
  | Scalar.Word w -> word w

let tensor = function
  | Tensor.Scalar x -> scalar x
  | Tensor.Vector _ -> not_implemented () (* TODO: implement *)
  | Tensor.Matrix _ -> not_implemented () (* TODO: implement *)

let datum = function
  | Datum.Interval _ -> not_implemented () (* TODO: implement *)
  | Datum.Quantity _ -> not_implemented () (* TODO: implement *)
  | Datum.String s -> Target.string s
  | Datum.Symbol s -> Target.form [symbol "quote"; Target.symbol s]
  | Datum.Tensor x -> tensor x
  | Datum.Unit _ -> not_implemented () (* TODO: implement *)

let rec translate_node = function
  | Node.Literal x -> datum x
  | Node.Id x -> Target.symbol x
  | Node.Name _ -> not_implemented () (* TODO: implement *)
  | Node.Import names -> not_implemented () (* TODO: implement *)
  | Node.Export names -> not_implemented () (* TODO: implement *)
  | Node.Apply (op, args) -> Target.form ((translate_node op) :: (List.map translate_node args))
  | Node.MathNeg a -> Target.form [symbol "-"; translate_node a]
  | Node.MathAdd (a, b) -> Target.form [symbol "+"; translate_node a; translate_node b]
  | Node.MathSub (a, b) -> Target.form [symbol "-"; translate_node a; translate_node b]
  | Node.MathMul (a, b) -> Target.form [symbol "*"; translate_node a; translate_node b]
  | Node.MathDiv (a, b) -> Target.form [symbol "/"; translate_node a; translate_node b]
  | Node.LogicNot a -> Target.form [symbol "not"; translate_node a]
  | Node.LogicAnd (a, b) -> Target.form [symbol "and"; translate_node a; translate_node b]
  | Node.LogicOr (a, b) -> Target.form [symbol "or"; translate_node a; translate_node b]
  | Node.If (a, b, c) -> Target.form [symbol "if"; translate_node a; translate_node b; translate_node c]
  | Node.Loop body -> Target.form ((symbol "loop") :: (List.map translate_node body))

let translate_module (module_ : Module.t) =
  Target.Program.make (List.map translate_node module_.code)

let translate_program (program : Program.t) =
  Target.Program.make (List.map translate_node program.code)

let compile_node ppf node =
  translate_node node |> Target.Expression.print ppf

let compile_module ppf module_ =
  translate_module module_ |> Target.Program.print ppf

let compile_program ppf program =
  translate_program program |> Target.Program.print ppf
