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

let post_list b =
  let%lwt rain_data = b.mf_client in
  let s = String.concat " " @@ List.map Rain_level.to_emoji rain_data in
  Lwt.return (`OK, s)

let get_command data =
  match List.assoc "text" data with
    | ["list"] -> `List
    | _ -> `Default
    | exception Not_found -> `Default

let respond b data =
  let%lwt (status, body) =
    match get_command data with
    | `Default -> post b
    | `List -> post_list b
  in
  Cohttp_lwt_unix.Server.respond_string ~status ~body ()

let callback b conn request request_body =
  let req_path =
    Uri.path (Cohttp.Request.uri request)
  in
  if req_path = b.path then
    let%lwt body_s = Cohttp_lwt_body.to_string request_body in
    let data = Uri.query_of_encoded body_s in
    respond b data
  else
    Cohttp_lwt_unix.Server.respond_not_found ()

let server b =
  Cohttp_lwt_unix.Server.make ~callback:(callback b) ()
