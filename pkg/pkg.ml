#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "rain-bot" @@ fun c ->
  Ok [
    Pkg.bin "bin/rain_bot";
    Pkg.test "test/testsuite";
  ]
