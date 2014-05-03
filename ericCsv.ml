open Printf
open Core
open Str
open String
open Char
#load "str.cma"

  
let file = "basketballSimple.csv"

let read_file filename =
  let lines = ref [] in
  let change = open_in filename in
  try
    while true; do
      lines := input_line change :: !lines
    done; []
  with End_of_file ->
    close_in_noerr change;
    List.rev !lines;;

let csv_parser strl = 
  match strl with
  | [] -> failwith "error"
  | z::tl -> for i = 0 to ((String.length z)-1) do
	       if phys_equal (int_of_char z.[i]) 13 then z.[i] <- (char_of_int 44) else ();
	     done	     
;;

let a = read_file file;;
csv_parser a;

List.map ~f:(fun x -> print_string x) a;;

let dd = match a with 
  | x :: _ -> x 
  | [] -> failwith " you fool";;

let reggy = Str.split (Str.regexp ",")  dd;;





(*  
let () =
  (* Read file and display the first line *)
  let ic = open_in file in
  try 
    let line = input_line ic in  (* read line from in_channel and discard \n *)
    let me = line in
    print_endline me;          (* write the result to stdout *)
    (*let me = stdout*)
    (*flush stdout;*)                (* write on the underlying device now *)
   (* close_in ic *)                 (* close the input channel *) 
  
  with e ->                      (* some unexpected exception occurs *)
    close_in_noerr ic;           (* emergency closing *)
    raise e                      (* exit with error: files are closed but
                                    channels are not flushed *)
  
  (* normal exit: all channels are flushed and closed *) *)
