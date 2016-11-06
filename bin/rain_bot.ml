let get_port () =
  try
    int_of_string (Sys.getenv "PORT")
  with Not_found -> 3000

let create_client () =
  let region_code =
    try
      Some (Sys.getenv "REGION_CODE")
    with Not_found -> None
  in
  match region_code with
  | Some c -> Some (Mf_client.of_region_code c)
  | None -> None

let () =
  let client = create_client () in
  let bot = Bot.create ?client () in
  let server = Bot.server bot in
  let mode = `TCP (`Port (get_port ())) in
  Lwt_main.run @@ Cohttp_lwt_unix.Server.create ~mode server
