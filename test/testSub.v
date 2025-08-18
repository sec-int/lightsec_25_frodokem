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

`include "main_core_serialCmd.v"

module testSub();
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

  reg done_fail = 1'b0;
  always @(posedge done_fail) $fatal(0, "ERROR! FAIL!");

    // o_in:  { size:`Outer_MaxWordLen bits }
    // o_out: { size:`Outer_MaxWordLen bits }
    // k_in:  { byteVal:8bits, skipIsLast:1bit, CMD:2bit } 
    // k_out: { skipIsLast:1bit, sample:1bit }
    // h:     { destination:4bit, source:4bit }  each is: { outer:1bit, keccak:1bit, memAndMul:1bit, seedA:1bit }
    // m:     { only command:5bit }
    // k:     { is128else256:1bit, inState:1bit, outState:1bit, mainIsInElseOut:1bit, mainNumBlocks:9bits, secondaryNumBlocks:1bits }
    // s:     { cmd_startIn:1bit, cmd_startOut:1bit }
  reg [`MainCoreCMD_which_SIZE+`MainCoreSerialCMD_SIZE-1:0] cmd = {`MainCoreCMD_which_SIZE+`MainCoreSerialCMD_SIZE{1'b0}};
  reg cmd_hasAny = 1'b0;
  wire cmd_consume;
  reg [64-1:0] in = 64'b0;
  reg in_isReady = 1'b0;
  wire in_canReceive;
  wire [64-1:0] out;
  wire out_isReady;
  reg out_canReceive = 1'b0;
  reg [`MemCONF_matrixNumBlocks_size-1:0] config_matrixNumBlocks = 8'b0;
  reg [3-1:0] config_parameter = 3'b0;
  reg rst = 1'b0;
  main_core_serialCmd toTest(
    .cmd(cmd),
    .cmd_hasAny(cmd_hasAny),
    .cmd_consume(cmd_consume),
    .in(in),
    .in_isReady(in_isReady),
    .in_canReceive(in_canReceive),
    .out(out),
    .out_isReady(out_isReady),
    .out_canReceive(out_canReceive),
    .conf({ config_matrixNumBlocks, config_parameter, config_parameter, config_parameter, config_parameter }),
    .rst(rst),
    .clk(clk)
  );

`define TEST_VARS 
`include "testSub__io.v"
`include "testSub__seedA.v"
`include "testSub__keccak.v"
`include "testSub__mem.v"
`include "testSub__memOp.v"
`undef TEST_VARS


`define TEST
`define DO_RST(testName, matrixSize, param) \
        @(negedge clk); \
        rst <= 1'b1; \
        config_matrixNumBlocks <= (matrixSize) >> 3; \
        config_parameter <= 1 << (param); \
        @(posedge clk); \
        test_name <= (testName); \
        @(negedge clk); \
        rst <= 1'b0; \
        @(posedge clk);


`define TEST_UTIL__CMD_SEND(c) \
        #0.1; \
        cmd <= (c); \
        cmd_hasAny <= 1'b1; \
        #0.1; \
        while(~cmd_consume) #1; \
        @(posedge clk); \
        cmd <= {`MainCoreCMD_which_SIZE+`MainCoreSerialCMD_SIZE{1'b0}}; \
        cmd_hasAny <= 1'b0;


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

`define TEST_UTIL__FAKE_SEND(v) \
        #0.1; \
        in <= (v); \
        #0.1; \
        while(~in_canReceive) #1; \
        #0.1; \
        @(posedge clk); \
        in <= 64'b0;

`define TEST_UTIL__SEND_CANT \
        #0.2; \
        if(in_canReceive) begin \
          $display("%t-%s: Must not say it can receive when it should be impossible!", $time, test_name); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk);

`define TEST_UTIL__SEND_DONT \
        #0.2; \
        if(~in_canReceive) begin \
          $display("%t-%s: Must not say it can't receive when it should be able to!", $time, test_name); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk);


`define TEST_UTIL__RECEIVE(v) \
        #0.15; \
        out_canReceive <= 1'b1; \
        #0.25; \
        while(~out_isReady) #1; \
        if(out !== (v)) begin \
          $display("%t-%s:\nReceived word: %h\ninstead of:    %h!", $time, test_name, out, (v)); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk); \
        out_canReceive <= 1'b0;

`define TEST_UTIL__RECEIVE_DONT \
        #0.4; \
        if(out_isReady) begin \
          $display("%t-%s: Must not say it's ready if it can't be received!", $time, test_name); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk);

`define TEST_UTIL__RECEIVE_CANT \
        #0.15; \
        out_canReceive <= 1'b1; \
        #0.25; \
        if(out_isReady) begin \
          $display("%t-%s: Output is ready when it should be impossible!", $time, test_name); \
          done_fail <= 1'b1; \
        end \
        @(posedge clk); \
        out_canReceive <= 1'b0;



  reg [50*8-1:0] test_name = "";
  initial begin : body
`include "testSub__io.v"
`include "testSub__seedA.v"
`include "testSub__keccak.v"
`include "testSub__mem.v"
`include "testSub__memOp.v"
    `DO_RST("DONE!", 0, 2)
    #3;
    $finish();
  end
`undef TEST

endmodule

