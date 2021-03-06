type t

val create :
  ?client:Mf_client.t ->
  unit -> t

val post : t -> (Cohttp.Code.status_code * string) Lwt.t

val post_list : t -> (Cohttp.Code.status_code * string) Lwt.t

val post_when : t -> (Cohttp.Code.status_code * string) Lwt.t

val server : t -> Cohttp_lwt_unix.Server.t
