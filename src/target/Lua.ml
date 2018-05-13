(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Source = Semantic
module Target = DRY.Code.Lua

let not_implemented () = failwith "not implemented yet"

let word = function
  | Word.Word8 _ -> not_implemented ()
  | Word.Word16 _ -> not_implemented ()
  | Word.Word32 _ -> not_implemented ()
  | Word.Word64 _ -> not_implemented ()

let number = function
  | Number.Float r -> Target.float r
  | Number.Int ((Int8 _) as z) -> Target.integer z
  | Number.Int ((Int16 _) as z) -> Target.integer z
  | Number.Int ((Int32 _) as z) -> Target.integer z
  | Number.Int ((Int64 _) as z) -> Target.integer z
  | Number.Int ((Int128 _)) -> not_implemented ()
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
  | Source.Node.Const x -> datum x
  | Source.Node.Var x -> Target.var (Symbol.to_string x)
  | Source.Node.Apply (op, args) ->
    begin match op with
    | Source.Node.Var fname -> Target.Expression.FunctionCall (fname, (List.map translate_node args))
    | _ -> failwith "invalid function call" (* TODO *)
    end
  | Source.Node.Not a -> Target.Expression.UnaryOperator (Not, translate_node a)
  | Source.Node.And (a, b) -> Target.Expression.BinaryOperator (And, translate_node a, translate_node b)
  | Source.Node.Or (a, b) -> Target.Expression.BinaryOperator (Or, translate_node a, translate_node b)
  | Source.Node.If (a, b, c) -> Target.Expression.If ((translate_node a), (translate_node b), (translate_node c))
  | Source.Node.Neg a -> Target.Expression.UnaryOperator (Neg, translate_node a)
  | Source.Node.Add (a, b) -> Target.Expression.BinaryOperator (Add, translate_node a, translate_node b)
  | Source.Node.Sub (a, b) -> Target.Expression.BinaryOperator (Sub, translate_node a, translate_node b)
  | Source.Node.Mul (a, b) -> Target.Expression.BinaryOperator (Mul, translate_node a, translate_node b)
  | Source.Node.Div (a, b) -> Target.Expression.BinaryOperator (Div, translate_node a, translate_node b)

let translate_module (module_ : Source.Module.t) =
  not_implemented ()

let translate_program (program : Source.Program.t) =
  not_implemented ()

let compile_node ppf node =
  translate_node node |> Target.print ppf

let compile_module ppf module_ =
  not_implemented ()

let compile_program ppf program =
  not_implemented ()
