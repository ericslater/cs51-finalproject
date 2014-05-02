open Core.Std

let file = "basketballSimple.csv"
  
let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; []
  with End_of_file ->
    close_in_noerr chan;
    List.rev !lines ;;
read_file file;;
