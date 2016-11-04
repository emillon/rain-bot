type t =
  { path : string
  }

let create () =
  { path = "/endpoint"
  }

let post b = 
  (`OK, "Peut être.")

let respond b =
  let (status, body) = post b in
  Cohttp_lwt_unix.Server.respond_string ~status ~body ()

let callback b conn request request_body =
  let req_path =
    Uri.path (Cohttp.Request.uri request)
  in
  if req_path = b.path then
    respond b
  else
    Cohttp_lwt_unix.Server.respond_not_found ()

let server b =
  Cohttp_lwt_unix.Server.make ~callback:(callback b) ()
