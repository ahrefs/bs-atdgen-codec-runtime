(** Test that encoding + decoding a value equals to the original value. *)

open Jest

let run_test ~name ~write ~read ~data =
  let open Expect in
  let encode = Atdgen_codec_runtime.Encode.encode write in
  let decode = Atdgen_codec_runtime.Decode.decode read in
  let json = encode data in
  let data' = decode json in
  test name (fun () ->
    expect data
    |> toEqual data'
  )

let () =
  describe "roundtrip tests" (fun () ->
    run_test
      ~name:"record"
      ~write:Test_bs.write_r
      ~read:Test_bs.read_r
      ~data:{Test_t.a = 1; b = "string";};
    run_test
      ~name:"record optional absent"
      ~write:Test_bs.write_ro
      ~read:Test_bs.read_ro
      ~data:{Test_t.c = "s"; o = None;};
    run_test
      ~name:"record optional present"
      ~write:Test_bs.write_ro
      ~read:Test_bs.read_ro
      ~data:{Test_t.c = "s"; o = Some 3L;};
    run_test
      ~name:"variant list"
      ~write:Test_bs.write_vl
      ~read:Test_bs.read_vl
      ~data:[Test_t.A 1; B "s"];
    run_test
      ~name:"variant poly list"
      ~write:Test_bs.write_vpl
      ~read:Test_bs.read_vpl
      ~data:[`A 1; `B "s"];
    run_test
      ~name:"tupple"
      ~write:Test_bs.write_t
      ~read:Test_bs.read_t
      ~data:(1, "s", 1.1);
    run_test
      ~name:"int nullable absent"
      ~write:Test_bs.write_n
      ~read:Test_bs.read_n
      ~data:None;
    run_test
      ~name:"int nullable present"
      ~write:Test_bs.write_n
      ~read:Test_bs.read_n
      ~data:(Some 1);
    run_test
      ~name:"int64"
      ~write:Test_bs.write_int64
      ~read:Test_bs.read_int64
      ~data:3L
  )