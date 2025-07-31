`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2025 04:12:12 PM
// Design Name: 
// Module Name: main
// Project Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "../src/main.v"

module testAll1344();
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

  wire [0:256-1] keygen_rnd_s [0:99];
  wire [0:512-1] keygen_rnd_seedSE [0:99];
  wire [0:128-1] keygen_rnd_z [0:99];
  wire [0:128-1] pk_seedA [0:99];
  wire [0:172032-1] pk_b [0:99];
  wire [0:256-1] sk_s [0:99];
  wire [0:172032-1] sk_S [0:99];
  wire [0:256-1] sk_pkh [0:99];
  wire [0:256-1] enc_rnd_mu [0:99];
  wire [0:512-1] enc_rnd_salt [0:99];
  wire [0:256-1] enc_ss [0:99];
  wire [0:172032-1] ct_c1 [0:99];
  wire [0:1024-1] ct_c2 [0:99];
  wire [0:512-1] ct_salt [0:99];
  wire [0:256-1] dec_ss [0:99];  
`include "vectors1344.v"


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
          $display("%t-%d:\nReceived word: %h\ninstead of:    %h!", $time, testNum, out, (v)); \
          /*done_fail <= 1'b1;*/ \
        end \
        @(posedge clk); \
        out_canReceive <= 1'b0;

`define TEST_UTIL__RECEIVE_ARRAY(v, j, size) \
        for(j = 0; j < (size); j = j+64) begin \
          `TEST_UTIL__RECEIVE(swapBytes64( v[j+:64] )) \
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


  reg [30*8-1:0] test_name = "";
  reg [30*8-1:0] IO_name = "";
  integer testNum = 0;
  integer j = 0;
  initial begin : body

    #5;
    `TEST_UTIL__CMD_SEND(`MainCMD_setParam1344)
    test_name = "keygen";
    for(testNum = 0; testNum < 1; testNum = testNum+1) begin
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      `TEST_UTIL__SEND_ARRAY(keygen_rnd_seedSE[testNum], j, 512)
      `TEST_UTIL__SEND_ARRAY(keygen_rnd_s[testNum], j, 256)
      `TEST_UTIL__SEND_ZEROS(j, 512)
      `TEST_UTIL__SEND_ARRAY(keygen_rnd_z[testNum], j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_keygen)

      IO_name = "sk_s";
      `TEST_UTIL__RECEIVE_ARRAY(sk_s[testNum], j, 256)
      IO_name = "sk_S";
      `TEST_UTIL__RECEIVE_ARRAY(sk_S[testNum], j, 172032)
      IO_name = "pk_seedA";
      `TEST_UTIL__RECEIVE_ARRAY(pk_seedA[testNum], j, 128)
      IO_name = "pk_b";
      `TEST_UTIL__RECEIVE_ARRAY(pk_b[testNum], j, 172032)
      IO_name = "sk_pkh";
      `TEST_UTIL__RECEIVE_ARRAY(sk_pkh[testNum], j, 256)

      #5;
    end

    test_name = "encaps";
    for(testNum = 0; testNum < 1; testNum = testNum+1) begin
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      `TEST_UTIL__SEND_ZEROS(j, 512)
      `TEST_UTIL__SEND_ARRAY(enc_rnd_mu[testNum], j, 256)
      `TEST_UTIL__SEND_ARRAY(enc_rnd_salt[testNum], j, 512)
      `TEST_UTIL__SEND_ZEROS(j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_encaps)

      `TEST_UTIL__SEND_ARRAY(pk_seedA[testNum], j, 128)
      `TEST_UTIL__SEND_ARRAY(pk_b[testNum], j, 172032)
      `TEST_UTIL__RECEIVE_ARRAY(ct_c1[testNum], j, 172032)
      `TEST_UTIL__RECEIVE_ARRAY(ct_c2[testNum], j, 1024)
      `TEST_UTIL__RECEIVE_ARRAY(ct_salt[testNum], j, 512)
      `TEST_UTIL__RECEIVE_ARRAY(enc_ss[testNum], j, 256)
      #5;
    end

    test_name = "decaps";
    for(testNum = 0; testNum < 1; testNum = testNum+1) begin
      #5;
      `TEST_UTIL__CMD_SEND(`MainCMD_setupTest)

      `TEST_UTIL__SEND_ZEROS(j, 512)
      `TEST_UTIL__SEND_ZEROS(j, 256)
      `TEST_UTIL__SEND_ZEROS(j, 512)
      `TEST_UTIL__SEND_ZEROS(j, 128)

      `TEST_UTIL__CMD_SEND(`MainCMD_decaps)

      `TEST_UTIL__SEND_ARRAY(sk_S[testNum], j, 172032)
      `TEST_UTIL__SEND_ARRAY(ct_c1[testNum], j, 172032)
      `TEST_UTIL__SEND_ARRAY(ct_c2[testNum], j, 1024)
      `TEST_UTIL__SEND_ARRAY(ct_salt[testNum], j, 512)
      `TEST_UTIL__SEND_ARRAY(sk_pkh[testNum], j, 256)
      `TEST_UTIL__SEND_ARRAY(pk_b[testNum], j, 172032)
      `TEST_UTIL__SEND_ARRAY(pk_seedA[testNum], j, 128)
      `TEST_UTIL__SEND_ARRAY(sk_s[testNum], j, 256)
      `TEST_UTIL__RECEIVE_ARRAY(dec_ss[testNum], j, 256)
      #5;
    end

    $finish();
  end
`undef TEST

endmodule

