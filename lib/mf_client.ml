type t = Rain_level.t list Lwt.t

let failing =
  Lwt.fail_with "Mf_client.failing"
