(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Source = Node
module Target = DRY.Code.Lua

let not_implemented () = failwith "not implemented yet"

let word = function
  | Word.Word8 w  -> Target.call "dry.word8"  [Target.integer (Int.of_int64 (Word8.as_int64 w))]
  | Word.Word16 w -> Target.call "dry.word16" [Target.integer (Int.of_int64 (Word16.as_int64 w))]
  | Word.Word32 w -> Target.call "dry.word32" [Target.integer (Int.of_int64 (Word32.as_int64 w))]
  | Word.Word64 w -> Target.call "dry.word64" [Target.integer (Int.of_int64 (Word64.as_int64 w))] (* FIXME: overflow? *)

let rec number = function
  | Number.Complex c            -> Target.call "dry.complex" [number (Number.Real c.real); number (Number.Real c.imaginary)]
  | Number.Float r              -> Target.call "dry.float" [Target.float r]
  | Number.Int ((Int8 _) as z)  -> Target.call "dry.int8" [Target.integer z]
  | Number.Int ((Int16 _) as z) -> Target.call "dry.int16" [Target.integer z]
  | Number.Int ((Int32 _) as z) -> Target.call "dry.int32" [Target.integer z]
  | Number.Int ((Int64 _) as z) -> Target.call "dry.int64" [Target.integer z]
  | Number.Int ((Int128 z))     -> Target.call "dry.int128" [Target.string (Int128.to_string z)]
  | Number.Integer z            -> Target.call "dry.integer" [Target.string (Integer.to_string z)] (* TODO: optimize *)
  | Number.Natural n            -> Target.call "dry.natural" [Target.string (Natural.to_string n)] (* TODO: optimize *)
  | Number.Rational q           -> Target.call "dry.rational" [number (Number.Integer q.numerator); number (Number.Integer q.denominator)]
  | Number.Real r               -> Target.call "dry.real" [Target.of_float (Real.to_float r)] (* FIXME: exactness *)

let scalar = function
  | Scalar.Bit b  -> Target.call "dry.bit" [Target.of_int (Bit.to_int b)]
  | Scalar.Bool b -> Target.call "dry.bool" [Target.boolean b]
  | Scalar.Char c -> Target.call "dry.char" [Target.of_int (Char.to_int c)]
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
  | Datum.Symbol s -> Target.call "dry.symbol" [Target.string (Symbol.to_string s)]
  | Datum.Tensor x -> tensor x
  | Datum.Unit _ -> not_implemented () (* TODO *)

let rec translate_expr = function
  | Node.Literal x -> datum x
  | Node.Id x -> Target.var (Symbol.to_string x)
  | Node.Name (_, []) -> assert false
  | Node.Name (pkg, name) -> Target.var (String.concat "." ("dry" :: (List.map Symbol.to_string name)))
  | Node.Import names -> not_implemented ()
  | Node.Export names -> not_implemented ()
  | Node.Apply (op, args) ->
    begin match op with
    | Node.Id fname ->
      Target.Expression.FunctionCall (fname, (List.map translate_expr args))
    | Node.Name (pkg, name) ->
      let fname = Symbol.of_string (String.concat "." (List.map Symbol.to_string (pkg :: name))) in
      Target.Expression.FunctionCall (fname, (List.map translate_expr args))
    | _ -> failwith "invalid function call" (* TODO: improve error *)
    end
  | Node.MathNeg a -> Target.Expression.UnaryOperator (Neg, translate_expr a)
  | Node.MathAdd (a, b) -> Target.Expression.BinaryOperator (Add, translate_expr a, translate_expr b)
  | Node.MathSub (a, b) -> Target.Expression.BinaryOperator (Sub, translate_expr a, translate_expr b)
  | Node.MathMul (a, b) -> Target.Expression.BinaryOperator (Mul, translate_expr a, translate_expr b)
  | Node.MathDiv (a, b) -> Target.Expression.BinaryOperator (Div, translate_expr a, translate_expr b)
  | Node.LogicNot a -> Target.Expression.UnaryOperator (Not, translate_expr a)
  | Node.LogicAnd (a, b) -> Target.Expression.BinaryOperator (And, translate_expr a, translate_expr b)
  | Node.LogicOr (a, b) -> Target.Expression.BinaryOperator (Or, translate_expr a, translate_expr b)
  | Node.If (a, b, c) -> Target.Expression.If ((translate_expr a), (translate_expr b), (translate_expr c))
  | Node.Loop body -> assert false

and translate_node = function
  | Node.Loop body -> Target.Statement.While (Target.of_bool true, List.map translate_node body)
  | node -> Target.Statement.LocalVarBind (Target.Name.of_string "_", translate_expr node)

let translate_module (module_ : Module.t) =
  not_implemented ()

let translate_program (program : Program.t) =
  not_implemented ()

let compile_node ppf node =
  Target.Block.make [translate_node node] |> Target.Block.print ppf

let compile_module ppf module_ =
  not_implemented ()

let compile_program ppf program =
  not_implemented ()
