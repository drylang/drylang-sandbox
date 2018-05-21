(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

module Source = Semantic
module Target = DRY.Code.Lisp

let not_implemented () = failwith "not implemented yet"

let symbol s = Target.symbol (Symbol.of_string s)

let word = function
  | Word.Word8 _ -> not_implemented ()
  | Word.Word16 _ -> not_implemented ()
  | Word.Word32 _ -> not_implemented ()
  | Word.Word64 _ -> not_implemented ()

let number = Target.number

let scalar = function
  | Scalar.Bool b -> Target.Object.of_bool b
  | Scalar.Char c -> Target.character c
  | Scalar.Number n -> number n
  | Scalar.Word w -> word w

let tensor = function
  | Tensor.Scalar x -> scalar x
  | Tensor.Vector _ -> not_implemented ()
  | Tensor.Matrix _ -> not_implemented ()

let datum = function
  | Datum.Symbol s -> Target.symbol s
  | Datum.Tensor x -> tensor x
  | _ -> not_implemented ()

let rec translate_node = function
  | Node.Literal x -> datum x
  | Node.Id x -> Target.symbol x
  | Node.Name _ -> not_implemented ()
  | Node.Import names -> not_implemented ()
  | Node.Export names -> not_implemented ()
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
