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

let run () : unit =
  let algorithm = parse_args () in
  algorithm
;;

run ()

;;

(*

(* Parse command-line arguments. Returns the appropriate initialization
  function to run and the current part. *)
let parse_args () : (unit -> unit) * int =
  let usage () = Printf.printf "usage: %s argument\n" Sys.argv.(0); exit 1 in
  if Array.length Sys.argv <> 2 then usage ();
  match Sys.argv.(1) with
  | "part1" -> part1_initializer, 1
  | "part2" -> part2_initializer, 2
  | "part3" -> part3_initializer, 3
  | "part4" | "part5" -> part4_initializer, 4
  | "final" | "part6" -> final_initializer, 6
  | _ -> usage ()


let run () : unit =
  let initialize, part = parse_args () in
  UI.run_world initialize (event_loop part)
;;

run () ;;

 *)
