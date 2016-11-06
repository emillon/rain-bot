type t = Rain_level.t list Lwt.t

let failing =
  Lwt.fail_with "Mf_client.failing"

type numeric_rain_level = Rain_level.t

let numeric_rain_level_of_yojson =
  let open Rain_level in
  function
  | `Int 1 -> Ok No_rain
  | `Int 2 -> Ok Low
  | `Int 3 -> Ok Medium
  | `Int 4 -> Ok High
  | _ -> Error "numeric_rain_level"

type dataCadran =
  { niveauPluie : numeric_rain_level
  }
  [@@deriving of_yojson { strict = false }]

type data =
  { dataCadran : dataCadran list
  }
  [@@deriving of_yojson { strict = false }]

let parse_json_response json =
  match data_of_yojson json with
  | Error _ as e -> e
  | Ok r ->
      Ok (List.map (fun x -> x.niveauPluie) r.dataCadran)

let of_uri uri =
  let error s =
    let msg = Printf.sprintf "Mf_client.of_url: %s" s in
    Lwt.fail_with msg
  in
  let%lwt (resp, body) = Cohttp_lwt_unix.Client.get uri in
  match Cohttp.Response.status resp with
  | `OK ->
      begin
        let%lwt json_string = Cohttp_lwt_body.to_string body in
        let json = Yojson.Safe.from_string json_string in
        match parse_json_response json with
        | Ok x -> Lwt.return x
        | Error e -> error "parse error"
      end
  | _ -> error "remote server returned an error"

let of_region_code code =
  of_uri @@ Uri.of_string @@ Printf.sprintf
    "http://www.meteofrance.com/mf3-rpc-portlet/rest/pluie/%s"
    code
