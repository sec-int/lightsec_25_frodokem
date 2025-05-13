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

`include "../src/main_core.v"

module test();
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

  reg done_fail = 1'b0;
  always @(posedge done_fail) $fatal(0, "ERROR! FAIL!");

    // { select which destination:`MainCoreCMD_which_SIZE bits, cmd:`MainCoreCMD_SIZE bits }
    // o_in:  { sampledFromStd:1bit, size:`Outer_MaxWordLen bits }
    // o_out: { sampledToStd:1bit, size:`Outer_MaxWordLen bits }
    // k_in:  { byteVal:8bits, skipIsLast:1bit, CMD:1bit }
    // k_out: { skipIsLast:1bit, sample:1bit }
    // k:     { is128else256, inState:1bit, outState:1bit, numInBlocks:16bits, numOutBlocks:16bits }
    // h:     { destination:4bit, source:4bit }  each is: { outer:1bit, keccak:1bit, memAndMul:1bit, seedA:1bit }
    // m:     { only command:5bit }
    // s:     { cmd_startIn:1bit, cmd_startOut:1bit }
  reg [`MainCoreCMD_which_SIZE+`MainCoreCMD_SIZE-1:0] cmd = {`MainCoreCMD_which_SIZE+`MainCoreCMD_SIZE{1'b0}};
  reg cmd_hasAny = 1'b0;
  wire cmd_consume;
  reg [64-1:0] in = 64'b0;
  reg in_isReady = 1'b0;
  wire in_canReceive;
  wire [64-1:0] out;
  wire out_isReady;
  reg out_canReceive = 1'b0;
  reg rst = 1'b0;
  main_core toTest(
    .cmd(cmd),
    .cmd_hasAny(cmd_hasAny),
    .cmd_consume(cmd_consume),
    .in(in),
    .in_isReady(in_isReady),
    .in_canReceive(in_canReceive),
    .out(out),
    .out_isReady(out_isReady),
    .out_canReceive(out_canReceive),
    .rst(rst),
    .clk(clk)
  );

`define TEST_VARS 
`include "test__io.v"
`include "test__seedA.v"
`include "test__keccak.v"
`include "test__mem.v"
`undef TEST_VARS


`define TEST
`define DO_RST   @(negedge clk) rst <= 1'b1; @(posedge clk) #0.01 rst <= 1'b0;
`define TEST_UTIL__CMD_SEND(c) \
        #0.1; \
        cmd <= c; \
        cmd_hasAny <= 1'b1; \
        #0.1; \
        while(~cmd_consume) #1; \
        @(posedge clk); \
        cmd <= {`MainCoreCMD_which_SIZE+`MainCoreCMD_SIZE{1'b0}}; \
        cmd_hasAny <= 1'b0;


`define TEST_UTIL__SEND(v) \
        #0.1; \
        in <= v; \
        #0.1; \
        while(~in_canReceive) #1; \
        #0.1; \
        if(in_canReceive) in_isReady <= 1'b1; \
        @(posedge clk); \
        in_isReady <= 1'b0; \
        in <= 64'b0;

`define TEST_UTIL__SEND_CANT \
        #0.2; \
        if(in_canReceive) begin \
          $display("%t: Must not say it can receive when it should be impossible!", $time); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk);

`define TEST_UTIL__SEND_DONT \
        #0.2; \
        if(~in_canReceive) begin \
          $display("%t: Must not say it can't receive when it should be able to!", $time); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk);


`define TEST_UTIL__RECEIVE(v) \
        #0.15; \
        out_canReceive <= 1'b1; \
        #0.25; \
        while(~out_isReady) #1; \
        if(out !== v) begin \
          $display("%t: Received word %h instead of %h!", $time, out, v); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk); \
        out_canReceive <= 1'b0;

`define TEST_UTIL__RECEIVE_DONT \
        #0.4; \
        if(out_isReady) begin \
          $display("%t: Must not say it's ready if it can't be received!", $time); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk);

`define TEST_UTIL__RECEIVE_CANT \
        #0.15; \
        out_canReceive <= 1'b1; \
        #0.25; \
        if(out_isReady) begin \
          $display("%t: Output is ready when it should be impossible!", $time); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk); \
        out_canReceive <= 1'b0;



  reg [30*8-1:0] test_name = "";
  initial begin : body
`include "test__io.v"
`include "test__seedA.v"
`include "test__keccak.v"
`include "test__mem.v"
    `DO_RST
    test_name <= "DONE!";
    #3;
    $finish();
  end
`undef TEST

endmodule

