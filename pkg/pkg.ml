#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "bot-pluie" @@ fun c ->
  Ok [
    Pkg.bin "bin/bot_pluie";
  ]
