open Syntax
open Eval

let rec read_eval_print env =
  print_string "# ";
  flush stdout;
  
  try 
    try let decl = Parser.toplevel Lexer.main (Lexing.from_channel stdin) in
      let (id, newenv, v) = eval_decl env decl in
      Printf.printf "val %s = " id;
      pp_val v;
      print_newline();
      read_eval_print newenv
    with Error e ->
      print_endline ("Error: " ^ e);
      read_eval_print env
  with Parsing.Parse_error ->
      print_endline "Parse Error";
      read_eval_print env

let initial_env = 
  Environment.extend "i" (IntV 1)
    (Environment.extend "ii" (IntV 2)
      (Environment.extend "iii" (IntV 3)
        (Environment.extend "iv" (IntV 4)    
          (Environment.extend "v" (IntV 5) 
            (Environment.extend "x" (IntV 10) Environment.empty)))))

let _ = read_eval_print initial_env
