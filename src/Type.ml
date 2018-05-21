(* This is free and unencumbered software released into the public domain. *)

open DRY.Core

type t =
  | Any
  | Bit
  | Bool
  | Char
  | Error
  | Function of t * t
  | Interval of t
  | Map of t * t
  | Matrix of t
  | None
  | Number
  | Option of t
  | Quantity of t
  | Result of t
  | Seq of t
  | Set of t
  | String
  | Symbol
  | Tuple2 of t * t
  | Tuple3 of t * t * t
  | Tuple4 of t * t * t * t
  | Type
  | Unit
  | Word

let rec to_string = function
  | Any -> "any"
  | Bit -> "bit"
  | Bool -> "bool"
  | Char -> "char"
  | Error -> "error"
  | Function (t, r) -> "(function " ^ (to_string t) ^ " " ^ (to_string r) ^ ")"
  | Interval t -> "(interval " ^ (to_string t) ^ ")"
  | Map (k, v) -> "(map " ^ (to_string k) ^ " " ^ (to_string v) ^ ")"
  | Matrix t -> "(matrix " ^ (to_string t) ^ ")"
  | None -> "none"
  | Number -> "number"
  | Option t -> "(option " ^ (to_string t) ^ ")"
  | Quantity t -> "(quantity " ^ (to_string t) ^ ")"
  | Result t -> "(result " ^ (to_string t) ^ ")"
  | Seq t -> "(seq " ^ (to_string t) ^ ")"
  | Set t -> "(set " ^ (to_string t) ^ ")"
  | String -> "string"
  | Symbol -> "symbol"
  | Tuple2 (t1, t2) -> "(tuple " ^ (to_string t1) ^ " " ^ (to_string t2) ^ ")"
  | Tuple3 (t1, t2, t3) -> "(tuple " ^ (to_string t1) ^ " " ^ (to_string t2) ^ " " ^ (to_string t3) ^ ")"
  | Tuple4 (t1, t2, t3, t4) -> "(tuple " ^ (to_string t1) ^ " " ^ (to_string t2) ^ " " ^ (to_string t3) ^ " " ^ (to_string t4) ^ ")"
  | Type -> "type"
  | Unit -> "unit"
  | Word -> "word"

let same_type a_type b_type =
  a_type

let rec of_node = function
  | Node.Literal datum -> of_term datum
  | Node.Id _ -> Any (* TODO *)
  | Node.Name _ -> Any (* TODO *)
  | Node.Import _ -> None
  | Node.Export _ -> None
  | Node.Apply (_, _) -> Any (* TODO*)
  | Node.MathNeg a -> of_node a
  | Node.MathAdd (a, b) -> same_type (of_node a) (of_node b)
  | Node.MathSub (a, b) -> same_type (of_node a) (of_node b)
  | Node.MathMul (a, b) -> same_type (of_node a) (of_node b)
  | Node.MathDiv (a, b) -> same_type (of_node a) (of_node b)
  | Node.LogicNot _ -> Bool
  | Node.LogicAnd (a, b) -> same_type (of_node a) (of_node b)
  | Node.LogicOr (a, b) -> same_type (of_node a) (of_node b)
  | Node.If (_, b, c) -> same_type (of_node b) (of_node c)
  | Node.Loop _ -> None

and of_term = function
  | Datum.Interval interval ->
    begin match interval with
    | Interval.Char _ -> Interval Char
    | Interval.Number _ -> Interval Number
    | Interval.Word _ -> Interval Word
    end
  | Datum.Quantity _ -> Any (* TODO *)
  | Datum.String _ -> String
  | Datum.Symbol _ -> Symbol
  | Datum.Tensor tensor ->
    begin match tensor with
    | Tensor.Scalar scalar ->
      begin match scalar with
      | Scalar.Bit _ -> Bit
      | Scalar.Bool _ -> Bool
      | Scalar.Char _ -> Char
      | Scalar.Number _ -> Number
      | Scalar.Word _ -> Word
      end
    | Tensor.Vector _ -> Any (* TODO: Seq *)
    | Tensor.Matrix _ -> Any (* TODO: Matrix *)
    end
  | Datum.Unit _ -> Unit
