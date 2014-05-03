open Core.Std
open RankingAlgorithms

(******************************************)
(*         TO TAKE IN USER INPUT          *)
(******************************************)

(* accepts team and score data from the user *)
let rec take_input () : string array =
  print_string "Give me a team, or type 'END': ";
  let team_line = read_line () in
    match team_line with
    | "END" -> [||]
    | team -> print_string "Give me a score: ";
	      let score = read_line () in
	        Array.append [|team_line|] 
			     (Array.append [|score|] (take_input ()))
;;

(* turns user input into a (string * int) list list *)
let rec to_data (sarray: string array) : (string * int) list list = 
  match sarray with
  | [||] -> []
  | array -> if Array.length sarray > 4
	     then [(array.(0), int_of_string(array.(1))); 
		   (array.(2), int_of_string(array.(3)))] :: 
		   (to_data (Array.sub sarray 4 
				       ((Array.length sarray) - 4)))
	     else [[(array.(0), int_of_string(array.(1))); 
		   (array.(2), int_of_string(array.(3)))]]
;;

(* prints a (string * int) list list for testing purposes! *)
let rec print_list (list: (string * int) list list) : unit =
  match list with
  | [] -> ()
  | hd :: tl -> let [(t1,s1);(t2,s2)] = hd in 
		print_string t1;
		print_newline ();
		print_int s1;
		print_newline ();
		print_string t2;
		print_newline ();
		print_int s2;
		print_newline ();
		print_list tl
;;

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

let rec choose_alg1 data =
  print_string "CHOOSE AN ALGORITHM (MINTON, MASSEY, COLLEY): ";
  let algo = read_line () in
  match String.uppercase algo with
  | "MINTON" -> RankingAlgorithms.calculate_minton (to_data data)
  | "MASSEY" -> RankingAlgorithms.calculate_massey (to_data data)
  | "COLLEY" -> RankingAlgorithms.calculate_colley (to_data data)
  | _ -> (print_string "INVALID INPUT.\n";
	  choose_alg1 data)
;;

let rec choose_alg2 () =
  print_string "CHOOSE AN ALGORITHM (MINTON, MASSEY, COLLEY): ";
  let algo = read_line () in
  match String.uppercase algo with
  | "MINTON" -> RankingAlgorithms.calculate_minton (to_data (take_input ()))
  | "MASSEY" -> RankingAlgorithms.calculate_massey (to_data (take_input ()))
  | "COLLEY" -> RankingAlgorithms.calculate_colley (to_data (take_input ()))
  | _ -> (print_string "INVALID INPUT.\n";
	  choose_alg2 ())
;;

let rec choose_type () = 
  print_string "CHOOSE YOUR DATA TYPE.\n
		CSV (c) OR MANUAL (m): ";
  let data_type = read_line () in
  match String.uppercase data_type with
  | "C" | "CSV" -> (print_string "PLEASE PROVIDE THE CSV FILENAME: ";
		    let fname = read_line () in
		    print_string "DOES YOUR CSV HAVE TITLE ROW? (y/n): ";
		    let input = read_line () in
		    let t_row = 
		      match input with
		      | "y" -> true
		      | _ -> false in
		    let data = csv_to_data fname t_row in
		    choose_alg1 data)
  | "M" | "MANUAL" -> choose_alg2 () 
;;

  choose_type ()
