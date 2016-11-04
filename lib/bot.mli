type t

val create : unit -> t

val post : t -> Cohttp.Code.status_code * string

val server : t -> Cohttp_lwt_unix.Server.t
