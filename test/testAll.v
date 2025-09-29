////    ////////////    Copyright (C) 2025 Giuseppe Manzoni, Barkhausen Institut
////    ////////////    
////                    This source describes Open Hardware and is licensed under the
////                    CERN-OHL-W v2 (https://cern.ch/cern-ohl)
////////////    ////    
////////////    ////    
////    ////    ////    
////    ////    ////    
////////////            Authors:
////////////            Giuseppe Manzoni (giuseppe.manzoni@barkhauseninstitut.org)


`timescale 1ns / 1ps


`include "../src/main.v"

module testAll();
  function [64-1:0] swapBytes64(input [64-1:0] in); begin
    swapBytes64[0*8+:8] = in[7*8+:8];
    swapBytes64[1*8+:8] = in[6*8+:8];
    swapBytes64[2*8+:8] = in[5*8+:8];
    swapBytes64[3*8+:8] = in[4*8+:8];
    swapBytes64[4*8+:8] = in[3*8+:8];
    swapBytes64[5*8+:8] = in[2*8+:8];
    swapBytes64[6*8+:8] = in[1*8+:8];
    swapBytes64[7*8+:8] = in[0*8+:8];
  end endfunction

  function [16-1:0] swapBytes16(input [16-1:0] in); begin
    swapBytes16[0*8+:8] = in[1*8+:8];
    swapBytes16[1*8+:8] = in[0*8+:8];
  end endfunction

  reg clk = 1'b1;
  initial forever #0.5 clk <= ~clk;

  reg rst = 1'b1;
  initial #1.3 rst <= 1'b0;

  reg done_fail = 1'b0;
  always @(posedge done_fail) $fatal(0, "ERROR! FAIL!");

  reg [`MainCMD_SIZE-1:0] cmd = {`MainCMD_SIZE{1'b0}};
  reg cmd_isReady = 1'b0;
  wire cmd_canReceive;
  reg [64-1:0] in = 64'b0;
  reg in_isReady = 1'b0;
  wire in_canReceive;
  wire [64-1:0] out;
  wire out_isReady;
  reg out_canReceive = 1'b0;
  main toTest(
    .cmd(cmd),
    .cmd_isReady(cmd_isReady),
    .cmd_canReceive(cmd_canReceive),
    .in(in),
    .in_isReady(in_isReady),
    .in_canReceive(in_canReceive),
    .out(out),
    .out_isReady(out_isReady),
    .out_canReceive(out_canReceive),
    .rst(rst),
    .clk(clk)
  );

`ifdef OUTPUT_INTERNALS_FOR_TEST
  `include "vectors640_i.v"
  `include "vectors976_i.v"
  `include "vectors1344_i.v"
`else
  `include "vectors640.v"
  `include "vectors976.v"
  `include "vectors1344.v"
`endif


`define TEST
`define TEST_UTIL__CMD_SEND(c) \
        while(~cmd_canReceive) #1; \
        #0.1; \
        cmd <= (c); \
        cmd_isReady <= 1'b1; \
        #1; \
        cmd <= {`MainCMD_SIZE{1'b0}}; \
        cmd_isReady <= 1'b0; \
        @(posedge clk);

`define TEST_UTIL__SEND(v) \
        #0.1; \
        in <= (v); \
        #0.1; \
        while(~in_canReceive) #1; \
        #0.1; \
        if(in_canReceive) in_isReady <= 1'b1; \
        @(posedge clk); \
        in_isReady <= 1'b0; \
        in <= 64'b0;

`define TEST_UTIL__SEND_ARRAY(v, j, size) \
        for(j = 0; j < (size); j = j+64) begin \
          `TEST_UTIL__SEND(swapBytes64( v[j+:64] )) \
        end

`define TEST_UTIL__SEND_ZEROS(j, size) \
        for(j = 0; j < (size); j = j+64) begin \
          `TEST_UTIL__SEND(64'b0) \
        end

`define TEST_UTIL__SEND_CANT \
        #0.2; \
        if(in_canReceive) begin \
          $display("%t-%d: Must not say it can receive when it should be impossible!", $time, testNum); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk);

`define TEST_UTIL__SEND_DONT \
        #0.2; \
        if(~in_canReceive) begin \
          $display("%t-%d: Must not say it can't receive when it should be able to!", $time, testNum); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk);

`define TEST_UTIL__RECEIVE(v) \
        #0.15; \
        out_canReceive <= 1'b1; \
        #0.25; \
        while(~out_isReady) #1; \
        if(out !== (v)) begin \
          $display("%t-%s:\nReceived word: %h  %b\ninstead of:    %h  %b!", $time, testNum, out, out, (v), (v)); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk); \
        out_canReceive <= 1'b0;

`define TEST_UTIL__RECEIVE_ARRAY(v, j, size) \
        for(j = 0; j < (size); j = j+64) begin \
          `TEST_UTIL__RECEIVE(swapBytes64( v[j+:64] )) \
        end

`define TEST_UTIL__RECEIVE_REPACK(v) \
        #0.15; \
        out_canReceive <= 1'b1; \
        #0.25; \
        while(~out_isReady) #1; \
        if((out & 64'h7fff7fff7fff7fff) !== ((v) & 64'h7fff7fff7fff7fff)) begin \
          $display("%t-%s:\nReceived word: %h  %b\ninstead of:    %h  %b!", $time, testNum, out, out, (v), (v)); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk); \
        out_canReceive <= 1'b0;

`define TEST_UTIL__RECEIVE_ARRAY_REPACK(v, j, size) \
        for(j = 0; j < (size); j = j+64) begin \
          `TEST_UTIL__RECEIVE_REPACK(swapBytes64( v[j+:64] )) \
        end

`define TEST_UTIL__RECEIVE_ZEROS(j, size) \
        for(j = 0; j < (size); j = j+64) begin \
          `TEST_UTIL__RECEIVE(64'b0) \
        end

`define TEST_UTIL__RECEIVE_DONT \
        #0.4; \
        if(out_isReady) begin \
          $display("%t-%d: Must not say it's ready if it can't be received!", $time, testNum); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk);

`define TEST_UTIL__RECEIVE_CANT \
        #0.15; \
        out_canReceive <= 1'b1; \
        #0.25; \
        if(out_isReady) begin \
          $display("%t-%d: Output is ready when it should be impossible!", $time, testNum); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk); \
        out_canReceive <= 1'b0;

`ifdef OUTPUT_INTERNALS_FOR_TEST
  reg [0:1024-1] v640_encode_internal_UminC;
  reg [16-1:0] v640_encode_internal_UminC__tmp;
  reg [0:1024-1] v640_encode_internal_MinE2;
  reg [16-1:0] v640_encode_internal_MinE2__tmp;

  reg [1600-1:0] v640_decode_internal_keccakState = 1600'hc48e95ba6ab6e6d3_4a81d77bdb76974c_c642754e1b009a7a_6ee67f7be83ad05e_acad47125bd73cc6_417ece1a21a97b6b_b22eabdd46a09520_440de1f477a00a22_3335f87dd268bbe1_4d0d6861b35b0b17_91b331c6c6ff15de_08e3c1c514793f20_28db23c7bb9f884c_e13b4ac16780d113_25308774c983b4bb_5f724b9ed8b4bbf1_3596b2131378ad8c_aced280ebb0e519e_c1441a9e33f944fe_00ec79fd23798fc1_bd1f69ebc8b6cc1d_f445eeaebdaa8e22_59797de05cbe3892_95f4d8e46fcc4ac0_a179f1e9ff66b80b;
`endif

  reg [30*8-1:0] test_name = "";
  reg [30*8-1:0] IO_name = "";
  integer testNum = 0;
  integer j = 0;
  initial begin : body

    #100
`ifdef OUTPUT_INTERNALS_FOR_TEST
    for(testNum = 0; testNum < 1; testNum = testNum+1) begin
`else
    for(testNum = 0; testNum < 100; testNum = testNum+1) begin
`endif

      `TEST_UTIL__CMD_SEND(`MainCMD_setParam640)

      #5;
      IO_name = "";
      test_name = "keygen-640";
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      IO_name = "rnd_seedSE";
      `TEST_UTIL__SEND_ARRAY(v640_keygen_rnd_seedSE[testNum], j, 256)
      IO_name = "rnd_s";
      `TEST_UTIL__SEND_ARRAY(v640_keygen_rnd_s[testNum], j, 128)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 256)
      IO_name = "rnd_z";
      `TEST_UTIL__SEND_ARRAY(v640_keygen_rnd_z[testNum], j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_keygen)

      IO_name = "sk_s";
      `TEST_UTIL__RECEIVE_ARRAY(v640_sk_s[testNum], j, 128)
      IO_name = "sk_S";
      `TEST_UTIL__RECEIVE_ARRAY(v640_sk_S[testNum], j, 81920)
      `ifdef OUTPUT_INTERNALS_FOR_TEST
        IO_name = "keygen_internal_E";
        `TEST_UTIL__RECEIVE_ARRAY(v640_keygen_internal_E[testNum], j, 81920)
      `endif
      IO_name = "pk_seedA";
      `TEST_UTIL__RECEIVE_ARRAY(v640_pk_seedA[testNum], j, 128)
      `ifdef OUTPUT_INTERNALS_FOR_TEST
        IO_name = "keygen_internal_A";
        `TEST_UTIL__RECEIVE_ARRAY(v640_keygen_internal_A_startAndEnd[testNum], j, 6553600)
        IO_name = "keygen_internal_B";
        `TEST_UTIL__RECEIVE_ARRAY(v640_keygen_internal_B[testNum], j, 81920)
      `endif
      IO_name = "pk_b";
      `TEST_UTIL__RECEIVE_ARRAY(v640_pk_b[testNum], j, 76800)
      IO_name = "sk_pkh";
      `TEST_UTIL__RECEIVE_ARRAY(v640_sk_pkh[testNum], j, 128)
      IO_name = "DONE!";
// */

      #5;
      IO_name = "";
      test_name = "encaps-640";
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 256)
      IO_name = "Mu";
      `TEST_UTIL__SEND_ARRAY(v640_enc_rnd_mu[testNum], j, 128)
      IO_name = "Salt";
      `TEST_UTIL__SEND_ARRAY(v640_enc_rnd_salt[testNum], j, 256)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_encaps)

      IO_name = "SeedA";
      `TEST_UTIL__SEND_ARRAY(v640_pk_seedA[testNum], j, 128)
      IO_name = "b";
      `TEST_UTIL__SEND_ARRAY(v640_pk_b[testNum], j, 76800)
      IO_name = "c1";
      `TEST_UTIL__RECEIVE_ARRAY(v640_ct_c1[testNum], j, 76800)
      IO_name = "c2";
      `TEST_UTIL__RECEIVE_ARRAY(v640_ct_c2[testNum], j, 960)
      IO_name = "salt";
      `TEST_UTIL__RECEIVE_ARRAY(v640_ct_salt[testNum], j, 256)
      IO_name = "ss";
      `TEST_UTIL__RECEIVE_ARRAY(v640_enc_ss[testNum], j, 128)
      IO_name = "DONE!";
// */

      #5;
      IO_name = "";
      test_name = "decaps-640";
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 256)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 128)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 256)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_decaps)

      IO_name = "S";
      `TEST_UTIL__SEND_ARRAY(v640_sk_S[testNum], j, 81920)
      IO_name = "c1";
      `TEST_UTIL__SEND_ARRAY(v640_ct_c1[testNum], j, 76800)
      IO_name = "c2";
      `TEST_UTIL__SEND_ARRAY(v640_ct_c2[testNum], j, 960)
      IO_name = "salt";
      `TEST_UTIL__SEND_ARRAY(v640_ct_salt[testNum], j, 256)
      `ifdef OUTPUT_INTERNALS_FOR_TEST
        IO_name = "SSState";
        for(j = 0; j < 1600; j = j+64) begin
          `TEST_UTIL__RECEIVE( v640_decode_internal_keccakState[j+:64] )
        end
      `endif
      IO_name = "pkh";
      `TEST_UTIL__SEND_ARRAY(v640_sk_pkh[testNum], j, 128)
      `ifdef OUTPUT_INTERNALS_FOR_TEST
        IO_name = "seedSE";
        `TEST_UTIL__RECEIVE_ARRAY(v640_encode_internal_seedSE[testNum], j, 256)
        IO_name = "k";
        `TEST_UTIL__RECEIVE_ARRAY(v640_encode_internal_k[testNum], j, 128)
        IO_name = "S";
        `TEST_UTIL__RECEIVE_ARRAY(v640_encode_internal_S[testNum], j, 81920)
        
        for(j = 0; j < 8*640; j=j+1) begin
          v640_encode_internal_UminC__tmp = swapBytes16(v640_encode_internal_V[testNum][16*j+:16]);
          v640_encode_internal_UminC__tmp = - v640_encode_internal_UminC__tmp;
          v640_encode_internal_UminC[16*j+:16] = swapBytes16(v640_encode_internal_UminC__tmp);
        end
        IO_name = "U-C ~-V";
        `TEST_UTIL__RECEIVE_ARRAY_REPACK(v640_encode_internal_UminC, j, 1024)
      `endif
      IO_name = "b";
      `TEST_UTIL__SEND_ARRAY(v640_pk_b[testNum], j, 76800)
      `ifdef OUTPUT_INTERNALS_FOR_TEST
        for(j = 0; j < 8*8; j=j+1) begin
          v640_encode_internal_MinE2__tmp = swapBytes16(v640_encode_internal_E2[testNum][16*j+:16]);
          v640_encode_internal_MinE2__tmp = - v640_encode_internal_MinE2__tmp;
          v640_encode_internal_MinE2[16*j+:16] = swapBytes16(v640_encode_internal_MinE2__tmp);
        end
        IO_name = "-E''";
        `TEST_UTIL__RECEIVE_ARRAY_REPACK(v640_encode_internal_MinE2, j, 1024)
        IO_name = "E'";
        `TEST_UTIL__RECEIVE_ARRAY_REPACK(v640_encode_internal_E[testNum], j, 81920)
        IO_name = "E''";
        `TEST_UTIL__RECEIVE_ARRAY_REPACK(v640_encode_internal_E2[testNum], j, 1024)
        IO_name = "C' - C";
        `TEST_UTIL__RECEIVE_ZEROS(j, 960)
      `endif
      IO_name = "seedA";
      `TEST_UTIL__SEND_ARRAY(v640_pk_seedA[testNum], j, 128)
      `ifdef OUTPUT_INTERNALS_FOR_TEST
        IO_name = "keygen_internal_A";
        `TEST_UTIL__RECEIVE_ARRAY(v640_keygen_internal_A_startAndEnd[testNum], j, 6553600)
        IO_name = "B' - B''";
        `TEST_UTIL__RECEIVE_ZEROS(j, 76800)
        IO_name = "C' - C";
        `TEST_UTIL__RECEIVE_ZEROS(j, 960)
      `endif
      IO_name = "s";
      `TEST_UTIL__SEND_ARRAY(v640_sk_s[testNum], j, 128)
      `ifdef OUTPUT_INTERNALS_FOR_TEST
        IO_name = "k'";
        `TEST_UTIL__RECEIVE_ARRAY(v640_encode_internal_k[testNum], j, 128)
      `endif
      IO_name = "ss";
      `TEST_UTIL__RECEIVE_ARRAY(v640_dec_ss[testNum], j, 128)
      IO_name = "DONE!";
      #5;
// */

      #5000;
      `TEST_UTIL__CMD_SEND(`MainCMD_setParam976)

      #5;
      IO_name = "";
      test_name = "keygen-976";
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      IO_name = "rnd_seedSE";
      `TEST_UTIL__SEND_ARRAY(v976_keygen_rnd_seedSE[testNum], j, 384)
      IO_name = "rnd_s";
      `TEST_UTIL__SEND_ARRAY(v976_keygen_rnd_s[testNum], j, 192)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 384)
      IO_name = "rnd_z";
      `TEST_UTIL__SEND_ARRAY(v976_keygen_rnd_z[testNum], j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_keygen)

      IO_name = "sk_s";
      `TEST_UTIL__RECEIVE_ARRAY(v976_sk_s[testNum], j, 192)
      IO_name = "sk_S";
      `TEST_UTIL__RECEIVE_ARRAY(v976_sk_S[testNum], j, 124928)
`ifdef OUTPUT_INTERNALS_FOR_TEST
      IO_name = "keygen_internal_E";
      `TEST_UTIL__RECEIVE_ARRAY(v976_keygen_internal_E[testNum], j, 124928)
`endif
      IO_name = "pk_seedA";
      `TEST_UTIL__RECEIVE_ARRAY(v976_pk_seedA[testNum], j, 128)
`ifdef OUTPUT_INTERNALS_FOR_TEST
      IO_name = "keygen_internal_A";
      `TEST_UTIL__RECEIVE_ARRAY(v976_keygen_internal_A_startAndEnd[testNum], j, 15241216)
      IO_name = "keygen_internal_B";
      `TEST_UTIL__RECEIVE_ARRAY(v976_keygen_internal_B[testNum], j, 124928)
`endif
      IO_name = "pk_b";
      `TEST_UTIL__RECEIVE_ARRAY(v976_pk_b[testNum], j, 124928)
      IO_name = "sk_pkh";
      `TEST_UTIL__RECEIVE_ARRAY(v976_sk_pkh[testNum], j, 192)
      IO_name = "DONE!";
// */

      #5;
      IO_name = "";
      test_name = "encaps-976";
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 384)
      IO_name = "Mu";
      `TEST_UTIL__SEND_ARRAY(v976_enc_rnd_mu[testNum], j, 192)
      IO_name = "salt";
      `TEST_UTIL__SEND_ARRAY(v976_enc_rnd_salt[testNum], j, 384)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_encaps)

      IO_name = "seedA";
      `TEST_UTIL__SEND_ARRAY(v976_pk_seedA[testNum], j, 128)
      IO_name = "b";
      `TEST_UTIL__SEND_ARRAY(v976_pk_b[testNum], j, 124928)
      IO_name = "c1";
      `TEST_UTIL__RECEIVE_ARRAY(v976_ct_c1[testNum], j, 124928)
      IO_name = "c2";
      `TEST_UTIL__RECEIVE_ARRAY(v976_ct_c2[testNum], j, 1024)
      IO_name = "salt";
      `TEST_UTIL__RECEIVE_ARRAY(v976_ct_salt[testNum], j, 384)
      IO_name = "ss";
      `TEST_UTIL__RECEIVE_ARRAY(v976_enc_ss[testNum], j, 192)
      IO_name = "DONE!";
// */

      #5;
      IO_name = "";
      test_name = "decaps-976";
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 384)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 192)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 384)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_decaps)

      IO_name = "S";
      `TEST_UTIL__SEND_ARRAY(v976_sk_S[testNum], j, 124928)
      IO_name = "c1";
      `TEST_UTIL__SEND_ARRAY(v976_ct_c1[testNum], j, 124928)
      IO_name = "c2";
      `TEST_UTIL__SEND_ARRAY(v976_ct_c2[testNum], j, 1024)
      IO_name = "salt";
      `TEST_UTIL__SEND_ARRAY(v976_ct_salt[testNum], j, 384)
      IO_name = "pkh";
      `TEST_UTIL__SEND_ARRAY(v976_sk_pkh[testNum], j, 192)
      IO_name = "b";
      `TEST_UTIL__SEND_ARRAY(v976_pk_b[testNum], j, 124928)
      IO_name = "seedA";
      `TEST_UTIL__SEND_ARRAY(v976_pk_seedA[testNum], j, 128)
      IO_name = "s";
      `TEST_UTIL__SEND_ARRAY(v976_sk_s[testNum], j, 192)
      IO_name = "ss";
      `TEST_UTIL__RECEIVE_ARRAY(v976_dec_ss[testNum], j, 192)
      IO_name = "DONE!";
      #5;
// */


      #5000;
      `TEST_UTIL__CMD_SEND(`MainCMD_setParam1344)

      #5;
      IO_name = "";
      test_name = "keygen-1344";
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      IO_name = "rnd_seedSE";
      `TEST_UTIL__SEND_ARRAY(v1344_keygen_rnd_seedSE[testNum], j, 512)
      IO_name = "rnd_s";
      `TEST_UTIL__SEND_ARRAY(v1344_keygen_rnd_s[testNum], j, 256)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 512)
      IO_name = "z";
      `TEST_UTIL__SEND_ARRAY(v1344_keygen_rnd_z[testNum], j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_keygen)

      IO_name = "sk_s";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_sk_s[testNum], j, 256)
      IO_name = "sk_S";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_sk_S[testNum], j, 172032)
`ifdef OUTPUT_INTERNALS_FOR_TEST
      IO_name = "keygen_internal_E";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_keygen_internal_E[testNum], j, 172032)
`endif
      IO_name = "pk_seedA";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_pk_seedA[testNum], j, 128)
`ifdef OUTPUT_INTERNALS_FOR_TEST
      IO_name = "keygen_internal_A";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_keygen_internal_A_startAndEnd[testNum], j, 28901376)
      IO_name = "keygen_internal_B";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_keygen_internal_B[testNum], j, 172032)
`endif
      IO_name = "pk_b";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_pk_b[testNum], j, 172032)
      IO_name = "sk_pkh";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_sk_pkh[testNum], j, 256)
      IO_name = "DONE!";
// */

      #5;
      IO_name = "";
      test_name = "encaps-1344";
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 512)
      IO_name = "Mu";
      `TEST_UTIL__SEND_ARRAY(v1344_enc_rnd_mu[testNum], j, 256)
      IO_name = "salt";
      `TEST_UTIL__SEND_ARRAY(v1344_enc_rnd_salt[testNum], j, 512)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_encaps)

      IO_name = "seedA";
      `TEST_UTIL__SEND_ARRAY(v1344_pk_seedA[testNum], j, 128)
      IO_name = "b";
      `TEST_UTIL__SEND_ARRAY(v1344_pk_b[testNum], j, 172032)
      IO_name = "c1";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_ct_c1[testNum], j, 172032)
      IO_name = "c2";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_ct_c2[testNum], j, 1024)
      IO_name = "salt";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_ct_salt[testNum], j, 512)
      IO_name = "ss";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_enc_ss[testNum], j, 256)
      IO_name = "DONE!";
// */

      #5;
      IO_name = "";
      test_name = "decaps-1344";
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 512)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 256)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 512)
      IO_name = "0";
      `TEST_UTIL__SEND_ZEROS(j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_decaps)

      IO_name = "S";
      `TEST_UTIL__SEND_ARRAY(v1344_sk_S[testNum], j, 172032)
      IO_name = "c1";
      `TEST_UTIL__SEND_ARRAY(v1344_ct_c1[testNum], j, 172032)
      IO_name = "c2";
      `TEST_UTIL__SEND_ARRAY(v1344_ct_c2[testNum], j, 1024)
      IO_name = "salt";
      `TEST_UTIL__SEND_ARRAY(v1344_ct_salt[testNum], j, 512)
      IO_name = "pkh";
      `TEST_UTIL__SEND_ARRAY(v1344_sk_pkh[testNum], j, 256)
      IO_name = "b";
      `TEST_UTIL__SEND_ARRAY(v1344_pk_b[testNum], j, 172032)
      IO_name = "seedA";
      `TEST_UTIL__SEND_ARRAY(v1344_pk_seedA[testNum], j, 128)
      IO_name = "s";
      `TEST_UTIL__SEND_ARRAY(v1344_sk_s[testNum], j, 256)
      IO_name = "ss";
      `TEST_UTIL__RECEIVE_ARRAY(v1344_dec_ss[testNum], j, 256)
      IO_name = "DONE!";
      #5;
// */

      #5000;
    end

    $finish();
  end
`undef TEST

endmodule

