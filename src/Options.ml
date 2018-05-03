(* This is free and unencumbered software released into the public domain. *)

open DRY.Core
open Cmdliner

module Stdlib   = DRY__Stdlib
module Filename = Stdlib.Filename
module String   = Stdlib.String

module Verbosity = struct
  type t = Normal | Quiet | Verbose

  let to_string = function
    | Normal -> "normal"
    | Quiet -> "quiet"
    | Verbose -> "verbose"
end

module WarningLevel = struct
  type t = None | Low | Medium | High

  let from_int = function
    | 0 -> None | 1 -> Low | 2 -> Medium | 3 | 4 | 5 | 6 | 7 | 8 | 9 -> High
    | _ -> failwith "invalid warning level"

  let from_string = function
    | "none" -> None
    | "all" | "extra" | "pedantic" -> High
    | s -> Stdlib.int_of_string s |> from_int

  let to_int = function
    | None -> 0 | Low -> 1 | Medium -> 2 | High -> 3

  let to_string opt =
    Printf.sprintf "%d" (to_int opt)
end

module OptimizationLevel = struct
  type t = None | Low | Medium | High

  let from_int = function
    | 0 -> None | 1 -> Low | 2 -> Medium | 3 | 4 | 5 | 6 | 7 | 8 | 9 -> High
    | _ -> failwith "invalid optimization level"

  let from_string = function
    | "none" | "g" -> None
    | "all" | "fast" | "s" -> High
    | s -> Stdlib.int_of_string s |> from_int

  let to_int = function
    | None -> 0 | Low -> 1 | Medium -> 2 | High -> 3

  let to_string opt =
    Printf.sprintf "%d" (to_int opt)
end

module CommonOptions = struct
  type t =
    { debug: bool;
      verbosity: Verbosity.t; }

  let make debug verbosity = { debug; verbosity; }
end

module OutputOptions = struct
  type t =
    { optimizations: OptimizationLevel.t; }

  let make optimizations = { optimizations; }
end

module TargetOptions = struct
  type t =
    { file: TargetFile.t;
      language: string option;
      optimizations: OptimizationLevel.t;
      warnings: WarningLevel.t; }

  let make file language optimizations warnings =
    { file; language; optimizations; warnings; }
end

let optimization_level =
  let doc = "Specify the optimization level (0..3; 0=none, 3=all)." in
  let converter =
    let parse s = Result.Ok (OptimizationLevel.from_string s) in
    let print ppf x = Format.fprintf ppf "%s" (OptimizationLevel.to_string x) in
    Arg.conv ~docv:"LEVEL" (parse, print)
  in
  Arg.(value & opt converter OptimizationLevel.None & info ["O"] ~docv:"LEVEL" ~doc)

let warning_level =
  let doc = "Specify the optimization level (0..3; 0=none, 3=all)." in
  let converter =
    let parse s = Result.Ok (WarningLevel.from_string s) in
    let print ppf x = Format.fprintf ppf "%s" (WarningLevel.to_string x) in
    Arg.conv ~docv:"LEVEL" (parse, print)
  in
  Arg.(value & opt converter WarningLevel.None & info ["W"] ~docv:"LEVEL" ~doc)

let package_root =
  let doc = "Overrides the default package index (\\$HOME/.dry)." in
  let env = Arg.env_var "DRY_ROOT" ~doc in
  let doc = "The package index root." in
  let def = Local.Index.default_path () in
  Arg.(value & opt dir def & info ["root"] ~env ~docv:"ROOT" ~doc)

let required_term idx doc =
  Arg.(required & pos idx (some string) None & info [] ~docv:"TERM" ~doc)

let optional_term idx doc =
  Arg.(value & pos idx (some string) None & info [] ~docv:"TERM" ~doc)

let input_file idx doc =
  Arg.(value & pos idx (some non_dir_file) None & info [] ~docv:"INPUT" ~doc)

let output_file =
  let doc = "The output file name." in
  Arg.(value & opt string "-" & info ["o"; "output"] ~docv:"OUTPUT" ~doc)

let output_language =
  let open Result in
  let doc = "The output language." in
  let converter =
    let parse s = if Target.is_supported s
      then Ok s
      else Error (`Msg "Unknown output language")
    in
    let print ppf p = Format.fprintf ppf "%s" p in
    Arg.conv ~docv:"LANG" (parse, print)
  in
  Arg.(value & opt (some converter) None & info ["L"; "language"] ~docv:"LANG" ~doc)

let source_file idx doc =
  let open Result in
  let converter =
    let parse = function
      | "" | "-" | "/dev/stdin" ->
        Ok (SourceFile.stdin)
      | filepath ->
        begin match Unix.stat filepath with
        | { st_kind = S_REG } ->
          Ok (SourceFile.open_user_program filepath)
        | _ ->
          Error (`Msg (Printf.sprintf "%s" "Not a file"))
        | exception Unix.Unix_error (error, _, _) ->
          Error (`Msg (Printf.sprintf "%s" (Unix.error_message error)))
        end
    in
    let print ppf p = Format.fprintf ppf "%s" (SourceFile.to_string p) in
    Arg.conv ~docv:"INPUT" (parse, print)
  in
  Arg.(value & pos idx converter SourceFile.stdin & info [] ~docv:"INPUT" ~doc)

let target_file doc =
  let open Result in
  let converter =
    let parse = function
      | "" | "-" | "/dev/stdout" -> Ok (TargetFile.stdout)
      | filepath ->
        begin let ext = Filename.extension filepath in
        match String.sub ext 1 (String.length ext - 1) with
        | exception Invalid_argument _ ->
          Error (`Msg (Printf.sprintf "missing output file extension: %s" filepath))
        | "" ->
          Error (`Msg (Printf.sprintf "invalid output file extension: %s" filepath))
        | ext when not (Target.is_supported ext) ->
          Error (`Msg (Printf.sprintf "unknown output file extension: %s" ext))
        | _ -> TargetFile.open_file filepath
        end
    in
    let print ppf p = Format.fprintf ppf "%s" (TargetFile.to_string p) in
    Arg.conv ~docv:"OUTPUT" (parse, print)
  in
  Arg.(value & opt converter TargetFile.stdout & info ["o"; "output"] ~docv:"OUTPUT" ~doc)

let common =
  let open Result in
  let debug =
    let doc = "Give only debug output." in
    Arg.(value & flag & info ["debug"] ~doc)
  in
  let verbosity =
    let doc = "Suppress informational output." in
    let quiet = Verbosity.Quiet, Arg.info ["q"; "quiet"] ~doc in
    let doc = "Give verbose output." in
    let verbose = Verbosity.Verbose, Arg.info ["v"; "verbose"] ~doc in
    Arg.(last & vflag_all [Verbosity.Normal] [quiet; verbose])
  in
  Term.(const CommonOptions.make $ debug $ verbosity)

let output =
  let open Result in
  Term.(const OutputOptions.make $ optimization_level)

let target =
  let open Result in
  Term.(const TargetOptions.make $ (target_file "The output file name.")
    $ output_language $ optimization_level $ warning_level)
