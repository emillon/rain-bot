let assert_text (code, data) expected =
  let open Alcotest in
  let code_str = Cohttp.Code.string_of_status code in
  let msg = "status should be 200" in
  check string msg (Cohttp.Code.string_of_status `OK) code_str;
  let msg = "response text" in
  check string msg expected data

let test_post () =
  let b = Bot.create () in
  let%lwt r = Bot.post b in
  assert_text r "Maybe.";
  Lwt.return_unit

let test_rain_output levels expected =
  let open Alcotest in
  let client = Lwt.return levels in
  let b = Bot.create ~client () in
  let%lwt r = Bot.post b in
  assert_text r expected;
  Lwt.return_unit

let test_post_list () =
  let open Rain_level in
  let levels = [No_rain; Low; Medium; High] in
  let client = Lwt.return levels in
  let b = Bot.create ~client () in
  let%lwt r = Bot.post_list b in
  assert_text r ":sunny: :partly_sunny_rain: :rain_cloud: :tornado:";
  Lwt.return_unit

let test_when levels expected =
  let client = Lwt.return levels in
  let b = Bot.create ~client () in
  let%lwt r = Bot.post_when b in
  assert_text r expected;
  Lwt.return_unit

let test_post_when_later () =
  let open Rain_level in
  let levels = [Low; Low; No_rain; No_rain; No_rain; High] in
  test_when levels "It will get better in 10 minutes."

let test_post_when_never () =
  let open Rain_level in
  let levels = [Low; Low; High; Medium; Low; High] in
  test_when levels "It does not look like it is going to get better."

let test_rain_ok () =
  let open Rain_level in
  test_rain_output [No_rain; No_rain] "It looks OK."

let test_rain_not_ok () =
  let open Rain_level in
  test_rain_output [No_rain; High] "You should take an umbrella."

let test_json_ok () =
  let open Rain_level in
  let open Alcotest in
  let json =
    `Assoc [
      "hasData", `Bool true;
      "dataCadran", `List [
        `Assoc [
          "niveauPluie", `Int 2;
          "color", `String "5ec5ed";
        ];
        `Assoc [
          "niveauPluie", `Int 1;
          "color", `String "ffffff";
        ];
      ]
    ]
  in
  let expected = Ok [Low;No_rain] in
  let res = Mf_client.parse_json_response json in
  check
    (result (list (module Rain_level)) string)
    "parsed json"
    expected
    res

let lwt_test f () =
  Lwt_main.run @@ f ()

let () =
  Alcotest.run "rain-bot"
    [ ("Bot", [
      ("Post", `Quick, lwt_test test_post);
      ("Post list", `Quick, lwt_test test_post_list);
      ("Post when", `Quick, lwt_test test_post_when_later);
      ("Post when", `Quick, lwt_test test_post_when_never);
      ])
    ; ("Rain", [
      ("OK", `Quick, lwt_test test_rain_ok);
      ("Not OK", `Quick, lwt_test test_rain_not_ok);
      ])
    ; ("JSON", [
      ("OK", `Quick, test_json_ok);
      ])
    ]
