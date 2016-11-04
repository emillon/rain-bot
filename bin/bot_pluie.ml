let get_port () =
  try
    int_of_string (Sys.getenv "PORT")
  with Not_found -> 3000

let () =
  let bot = Bot.create () in
  let server = Bot.server bot in
  let mode = `TCP (`Port (get_port ())) in
  Lwt_main.run @@ Cohttp_lwt_unix.Server.create ~mode server
