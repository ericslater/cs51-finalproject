open Core.Std
open RankingAlgorithms

(* Parse command-line arguments. Returns the appropriate initialization
  function to run and the current part. *)
let parse_args () : (((string * int) list list) -> unit) =
  let usage () = Printf.printf "usage: %s argument\n" Sys.argv.(0); exit 1 in
  if Array.length Sys.argv <> 2 then usage ();
  match Sys.argv.(1) with
  | "Minton" -> calculate_minton Sys.argv.(2)
  | "Massey" -> calculate_massey Sys.argv.(2)
  | "Colley" -> calculate_colley Sys.argv.(2)
  | _ -> usage ()
;;
