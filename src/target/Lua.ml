(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Source = Semantic
module Target = DRY.Code.Lua

let not_implemented () = failwith "not implemented yet"

let word = function
  | Word.Word8 _  -> not_implemented ()
  | Word.Word16 _ -> not_implemented ()
  | Word.Word32 _ -> not_implemented ()
  | Word.Word64 _ -> not_implemented ()

let number = function
  | Number.Float r -> Target.call "dry.float" [Target.float r]
  | Number.Int ((Int8 _) as z)  -> Target.call "dry.int8"   [Target.integer z]
  | Number.Int ((Int16 _) as z) -> Target.call "dry.int16"  [Target.integer z]
  | Number.Int ((Int32 _) as z) -> Target.call "dry.int32"  [Target.integer z]
  | Number.Int ((Int64 _) as z) -> Target.call "dry.int64"  [Target.integer z]
  | Number.Int ((Int128 z))     -> Target.call "dry.int128" [Target.string (Int128.to_string z)]
  | _ -> not_implemented ()

let scalar = function
  | Scalar.Bool b -> Target.call "dry.bool" [Target.boolean b]
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

let rec translate_expr = function
  | Source.Node.Const x -> datum x
  | Source.Node.Id x -> Target.var (Symbol.to_string x)
  | Source.Node.Name (_, []) -> assert false
  | Source.Node.Name (pkg, name) -> Target.var (String.concat "." ("dry" :: (List.map Symbol.to_string name)))
  | Source.Node.Import names -> not_implemented ()
  | Source.Node.Export names -> not_implemented ()
  | Source.Node.Apply (op, args) ->
    begin match op with
    | Source.Node.Id fname ->
      Target.Expression.FunctionCall (fname, (List.map translate_expr args))
    | Source.Node.Name (pkg, name) ->
      let fname = Symbol.of_string (String.concat "." (List.map Symbol.to_string (pkg :: name))) in
      Target.Expression.FunctionCall (fname, (List.map translate_expr args))
    | _ -> failwith "invalid function call" (* TODO *)
    end
  | Source.Node.MathNeg a -> Target.Expression.UnaryOperator (Neg, translate_expr a)
  | Source.Node.MathAdd (a, b) -> Target.Expression.BinaryOperator (Add, translate_expr a, translate_expr b)
  | Source.Node.MathSub (a, b) -> Target.Expression.BinaryOperator (Sub, translate_expr a, translate_expr b)
  | Source.Node.MathMul (a, b) -> Target.Expression.BinaryOperator (Mul, translate_expr a, translate_expr b)
  | Source.Node.MathDiv (a, b) -> Target.Expression.BinaryOperator (Div, translate_expr a, translate_expr b)
  | Source.Node.LogicNot a -> Target.Expression.UnaryOperator (Not, translate_expr a)
  | Source.Node.LogicAnd (a, b) -> Target.Expression.BinaryOperator (And, translate_expr a, translate_expr b)
  | Source.Node.LogicOr (a, b) -> Target.Expression.BinaryOperator (Or, translate_expr a, translate_expr b)
  | Source.Node.If (a, b, c) -> Target.Expression.If ((translate_expr a), (translate_expr b), (translate_expr c))
  | Source.Node.Loop body -> assert false

and translate_node = function
  | Source.Node.Loop body -> Target.Statement.While (Target.of_bool true, List.map translate_node body)
  | node -> Target.Statement.LocalVarBind (Target.Name.of_string "_", translate_expr node)

let translate_module (module_ : Source.Module.t) =
  not_implemented ()

let translate_program (program : Source.Program.t) =
  not_implemented ()

let compile_node ppf node =
  Target.Block.make [translate_node node] |> Target.Block.print ppf

let compile_module ppf module_ =
  not_implemented ()

let compile_program ppf program =
  not_implemented ()
