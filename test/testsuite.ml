let assert_200 (code, _) =
  let open Alcotest in
  let code_str = Cohttp.Code.string_of_status code in
  let msg = "status should be 200" in
  check string msg code_str (Cohttp.Code.string_of_status `OK)

let assert_text (_, data) expected =
  let open Alcotest in
  let msg = "response text" in
  check string msg data expected

let test_post () =
  let b = Bot.create () in
  let r = Bot.post b in
  assert_200 r;
  assert_text r "Peut être."

let () =
  Alcotest.run "Bot-pluie"
    [ ("Post", [("Response", `Quick, test_post)])
    ]
