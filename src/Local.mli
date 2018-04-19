(* This is free and unencumbered software released into the public domain. *)

(** Local term. *)
module Term : sig
  type t =
    { name: DRY.Core.Symbol.t;
      path: string;
      filepath: string; }

  val make : ?filepath:string -> ?path:string -> string -> t

  val to_string : t -> string
end

(** Local module. *)
module Module : sig
  type t =
    { name: DRY.Core.Symbol.t;
      path: string;
      dirpath: string; }

  val make : ?dirpath:string -> ?path:string -> string -> t

  val iter_terms : t -> (Term.t -> unit) -> unit

  val iter_modules : t -> (t -> unit) -> unit

  val to_string : t -> string
end

(** Local package. *)
module Package : sig
  type t =
    { name: DRY.Core.Symbol.t;
      path: string;
      dirpath: string; }

  val make : ?dirpath:string -> ?path:string -> string -> t

  val iter_modules : t -> (Module.t -> unit) -> unit

  val to_string : t -> string
end

(** Local package index. **)
module Index : sig
  type t =
    { dirpath: string; }

  val default_path : unit -> string

  val open_default : unit -> t

  val open_path : string -> t

  val iter_packages : t -> (Package.t -> unit) -> unit

  val to_string : t -> string
end
