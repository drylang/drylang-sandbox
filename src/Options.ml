(* This is free and unencumbered software released into the public domain. *)

open Cmdliner

module Verbosity = struct
  type t = Normal | Quiet | Verbose

  let to_string = function
    | Normal -> "normal"
    | Quiet -> "quiet"
    | Verbose -> "verbose"
end

module Common = struct
  type t =
    { debug: bool;
      verbosity: Verbosity.t; }

  let make debug verbosity = { debug; verbosity; }
end

let common =
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
  Term.(const Common.make $ debug $ verbosity)

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

let output_language =
  let doc = "The output language." in
  let lang =
    let parse s = if Target.is_supported s
      then Result.Ok s
      else Result.Error (`Msg "unknown output language")
    in
    let print ppf p = Format.fprintf ppf "%s" p in
    Arg.conv ~docv:"LANG" (parse, print)
  in
  Arg.(value & opt lang "dry" & info ["L"; "language"] ~docv:"LANG" ~doc)

let output_file =
  let doc = "The output file name." in
  Arg.(value & opt string "-" & info ["o"; "output"] ~docv:"OUTPUT" ~doc)
