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

RankingAlgorithms.calculate_massey (to_data (take_input ()))
RankingAlgorithms.calculate_minton (to_data (take_input ()))
RankingAlgorithms.calculate_colley (to_data (take_input ()));;


