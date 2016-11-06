type t = Rain_level.t list Lwt.t

val failing : t

val parse_json_response : Yojson.Safe.json ->
  (Rain_level.t list, string) result

val of_uri : Uri.t -> t

(** Use meteo france's service from a given region code *)
val of_region_code : string -> t
