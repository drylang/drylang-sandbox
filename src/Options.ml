(* This is free and unencumbered software released into the public domain. *)

open Cmdliner

module PackageRoot = struct
  let term =
    let doc = "Overrides the default package index (\\$HOME/.dry)." in
    let env = Arg.env_var "DRY_ROOT" ~doc in
    let doc = "The package index root." in
    let def = Local.Index.default_path () in
    Arg.(value & opt dir def & info ["root"] ~env ~docv:"ROOT" ~doc)
end

module Verbosity = struct
  type t = Normal | Quiet | Verbose

  let to_string = function
    | Normal -> "normal"
    | Quiet -> "quiet"
    | Verbose -> "verbose"
end

type t =
  { debug: bool;
    verbosity: Verbosity.t; }

let make debug verbosity =
  { debug; verbosity; }

let term =
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
  Term.(const make $ debug $ verbosity)
