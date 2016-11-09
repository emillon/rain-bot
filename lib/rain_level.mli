type t =
  | No_rain
  | Low
  | Medium
  | High
  [@@deriving eq,show]

val to_emoji : t -> string
