type t = Rain_level.t list Lwt.t

val failing : t

val parse_json_response : Yojson.Safe.json ->
  (Rain_level.t list, string) result

val of_uri : Uri.t -> t
