type t =
  { path : string
  ; mf_client : Mf_client.t
  }

let create ?(client=Mf_client.failing) () =
  { path = "/endpoint"
  ; mf_client = client
  }

let post b = 
  try%lwt
    let%lwt rain_data = b.mf_client in
    if List.for_all (fun l -> l = Rain_level.No_rain) rain_data then
      Lwt.return (`OK, "It looks OK.")
    else
      Lwt.return (`OK, "You should take an umbrella.")
  with _ ->
    Lwt.return (`OK, "Maybe.")

let respond b =
  let%lwt (status, body) = post b in
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
