type t =
  | No_rain
  | Low
  | Medium
  | High
  [@@deriving eq,show]

let to_emoji = function
  | No_rain -> ":sunny:"
  | Low -> ":partly_sunny_rain:"
  | Medium -> ":rain_cloud:"
  | High -> ":tornado:"
