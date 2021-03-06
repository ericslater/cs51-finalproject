open Printf
open Core
open Str
open String
open Char
open Array

  
let file = "basketballSimple.csv"

let csv_to_data (file : string) (b : bool) : string array = 

  let read_file filename =
    let lines = ref [] in
    let change = open_in filename in
    try
      while true; do
	lines := input_line change :: !lines
      done; []
    with End_of_file ->
      close_in_noerr change;
      List.rev !lines in

  let csv_parser strl = 
    match strl with
    | [] -> failwith "csv_parser error"
    | z::tl -> for i = 0 to ((String.length z)-1) do
		 if phys_equal (int_of_char z.[i]) 13 then z.[i] <- (char_of_int 44) else ();
	       done; z in

  let onereg (a : string) : string list = Str.split (Str.regexp ",") a in

  let rec datamake (slist : string list) (a : bool) = 
    if a then 
      match slist with 
      | [] -> [||]
      | _::_::_::_::tl -> datamake tl false
    else 
      match slist with
      | [] -> [||]
      | hd::tl -> Array.append [|hd|] (datamake tl false) in

  datamake (onereg (csv_parser (read_file file))) b
		 
;;
(*
let here = csv_to_data "basketballSimple.csv" true;;

  open_in "basketballSimple.csv";;


let a = read_file file;;



csv_parser a;

List.map ~f:(fun x -> print_string x) a;;

let dd = match a with 
  | x :: _ -> x 
  | [] -> failwith " you fool";;

let reggy = Str.split (Str.regexp ",")  dd;;

let rec datamake slist a = 
  if a then 
    match slist with 
    | [] -> [||]
    | _::_::_::_::tl -> datamake tl false
  else 
    match slist with
    | [] -> [||]
    | hd::tl -> Array.append [|hd|] (datamake tl false)
;;

let arrayreggy = datamake reggy true;; 
 *)
