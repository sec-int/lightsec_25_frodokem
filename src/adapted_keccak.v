`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2025 04:12:12 PM
// Design Name: 
// Module Name: main
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

`include "keccak.v"

`define KeccakInCMD_sendByte  2'b00
`define KeccakInCMD_sendZeros 2'b01
`define KeccakInCMD_forward   2'b10
`define KeccakInCMD_SIZE  (8+1+2)

`ATTR_MOD_GLOBAL
module adapted_keccak__in(
    input [`KeccakInCMD_SIZE-1:0] cmd,  // {byteVal:8bits, skipIsLast:1bit, CMD:2bit}
    input cmd_isReady,
    output cmd_canReceive,

    input [64-1:0] h__out,
    input h__out_isReady,
    output h__out_canReceive,
    output h__out_isLast_in,
    input h__out_isLast_out,

    output [64-1:0] k__in,
    output k__in_isSingleByte, 
    output k__in_isLast,
    output k__in_isReady,
    input k__in_canReceive,

    input rst,
    input clk
  );
  wire [`KeccakInCMD_SIZE-1:0] cmdB;
  wire cmdB_hasAny;
  wire cmdB_consume;
  cmd_buffer #(.CmdSize(`KeccakInCMD_SIZE), .BufSize(2)) cmdBuf (
    .i(cmd),
    .i_isReady(cmd_isReady),
    .i_canReceive(cmd_canReceive),
    .o(cmdB),
    .o_hasAny(cmdB_hasAny),
    .o_consume(cmdB_consume),
    .rst(rst),
    .clk(clk)
  );
  wire cmdB_sendByte  = cmdB[0+:2] == `KeccakInCMD_sendByte & cmdB_hasAny;
  wire cmdB_sendZeros = cmdB[0+:2] == `KeccakInCMD_sendZeros & cmdB_hasAny;
  wire cmdB_forward   = cmdB[0+:2] == `KeccakInCMD_forward & cmdB_hasAny;
  wire cmdB_skipIsLast = cmdB[2];
  wire [8-1:0] cmdB_byteVal = cmdB[3+:8];

  wire zerosCounter__canRestart, zerosCounter__canReceive, zerosCounter__canReceive_isLast;
  wire isReady = zerosCounter__canReceive & k__in_canReceive;
  counter_bus #(.N(8)) zerosCounter (
    .restart(cmdB_sendZeros),
    .numSteps(cmdB_byteVal),
    .canRestart(zerosCounter__canRestart),
    .canReceive(zerosCounter__canReceive),
    .canReceive_isLast(zerosCounter__canReceive_isLast),
    .isReady(isReady),
    .rst(rst),
    .clk(clk)
  );

  assign cmdB_consume = cmdB_sendByte & k__in_canReceive
                      | cmdB_forward & h__out_isLast_out
                      | cmdB_sendZeros & zerosCounter__canRestart;

  assign h__out_isLast_in = 1'b0; // disabled
  assign h__out_canReceive = cmdB_forward & k__in_canReceive;

  assign k__in_isLast = ~cmdB_skipIsLast & cmdB_sendByte  & k__in_canReceive
                      | ~cmdB_skipIsLast & cmdB_forward   & h__out_isLast_out
                      | ~cmdB_skipIsLast & cmdB_sendZeros & zerosCounter__canReceive_isLast;
  
  assign k__in_isSingleByte = cmdB_sendByte;
  assign k__in = (cmdB_sendByte ? {56'b0, cmdB_byteVal} : 64'b0)
               | (cmdB_forward ? h__out : 64'b0);
  assign k__in_isReady = cmdB_sendByte & k__in_canReceive
                       | cmdB_forward & h__out_isReady
                       | cmdB_sendZeros & isReady;
endmodule


`define KeccakOutCMD_SIZE  2

`define FRODO_T0 15'd9142
`define FRODO_T1 15'd23462
`define FRODO_T2 15'd30338
`define FRODO_T3 15'd32361
`define FRODO_T4 15'd32725
`define FRODO_T5 15'd32765

// LUT4    2
// LUT6   17
// Sl.LUT 19
`ATTR_MOD_GLOBAL
module sampler_single(
    input [16-1:0] in,
    output [4-1:0] out
  );
  wire [15-1:0] val = in[15:1];

  assign out[3] = in[0]; // isNeg
  assign out[2] = val > `FRODO_T3;
  assign out[1] = val > `FRODO_T1 && val <= `FRODO_T3
               || val > `FRODO_T5;
  assign out[0] = val > `FRODO_T0 && val <= `FRODO_T1
               || val > `FRODO_T2 && val <= `FRODO_T3
               || val > `FRODO_T4 && val <= `FRODO_T5;
endmodule

`ATTR_MOD_GLOBAL
module compactToStd_single(
  input [4-1:0] in,
  output [16-1:0] out
);
  wire isNeg = in[3];
  wire [16-1:0] mod = {13'b0, in[3-1:0]};

  assign out = isNeg ? -mod : mod;
endmodule

`ATTR_MOD_GLOBAL
module sampler(
    input enable,
    input [64-1:0] in,
    output [64-1:0] out
  );
  wire [16-1:0] out_sampled;
  wire [64-1:0] out_std;
  sampler_single s0(in[16*0+:16], out_sampled[4*0+:4]);
  sampler_single s1(in[16*1+:16], out_sampled[4*1+:4]);
  sampler_single s2(in[16*2+:16], out_sampled[4*2+:4]);
  sampler_single s3(in[16*3+:16], out_sampled[4*3+:4]);
  compactToStd_single c0(out_sampled[4*0+:4], out_std[16*0+:16]);
  compactToStd_single c1(out_sampled[4*1+:4], out_std[16*1+:16]);
  compactToStd_single c2(out_sampled[4*2+:4], out_std[16*2+:16]);
  compactToStd_single c3(out_sampled[4*3+:4], out_std[16*3+:16]);
  assign out = enable ? out_std : in;
endmodule

`ATTR_MOD_GLOBAL
module adapted_keccak__out(
    input [`KeccakOutCMD_SIZE-1:0] cmd, // {skipIsLast:1bit, sample:1bit}
    input cmd_isReady,
    output cmd_canReceive,

    output [64-1:0] h__in,
    output h__in_isReady,
    input h__in_canReceive,
    output h__in_isLast_in,
    input h__in_isLast_out,

    input [64-1:0] k__out,
    input k__out_isReady,
    output k__out_canReceive,
    output k__out_isLast,

    input rst,
    input clk
  );

  wire [`KeccakOutCMD_SIZE-1:0] cmdB;
  wire cmdB_hasAny;
  wire cmdB_consume;
  cmd_buffer #(.CmdSize(`KeccakOutCMD_SIZE), .BufSize(2)) cmdBuf (
    .i(cmd),
    .i_isReady(cmd_isReady),
    .i_canReceive(cmd_canReceive),
    .o(cmdB),
    .o_hasAny(cmdB_hasAny),
    .o_consume(cmdB_consume),
    .rst(rst),
    .clk(clk)
  );
  wire cmdB_forward = cmdB_hasAny; // the only primary command
  wire cmdB_skipIsLast = cmdB[1];
  wire cmdB_sample = cmdB[0];

  assign cmdB_consume = h__in_isLast_out;

  sampler sampler(cmdB_sample, k__out, h__in);

  assign h__in_isReady = cmdB_forward & k__out_isReady;
  assign h__in_isLast_in = 1'b0; // disabled
  assign k__out_canReceive = cmdB_forward & h__in_canReceive;
  assign k__out_isLast = ~cmdB_skipIsLast & cmdB_forward & h__in_isLast_out;
endmodule

`define KeccakAdaptedCMD_SIZE  (4 + `Keccak_BlockCounterSize + 1)

`ATTR_MOD_GLOBAL
module adapted_keccak (
    input [`KeccakInCMD_SIZE-1:0] k_in__cmd,  // {byteVal:8bits, skipIsLast:1bit, CMD:1bit}
    input k_in__cmd_isReady,
    output k_in__cmd_canReceive,

    input [`KeccakOutCMD_SIZE-1:0] k_out__cmd, // {skipIsLast:1bit, sample:1bit}
    input k_out__cmd_isReady,
    output k_out__cmd_canReceive,

    input [`KeccakAdaptedCMD_SIZE-1:0] k__cmd, // { is128else256:1bit, inState:1bit, outState:1bit, mainIsInElseOut:1bit, mainNumBlocks:9bits, secondaryNumBlocks:1bits }
    input k__cmd_isReady,
    output k__cmd_canReceive,

    input [64-1:0] h__out,
    input h__out_isReady,
    output h__out_canReceive,
    output h__out_isLast_in,
    input h__out_isLast_out,

    output [64-1:0] h__in,
    output h__in_isReady,
    input h__in_canReceive,
    output h__in_isLast_in,
    input h__in_isLast_out,

    input rst,
    input clk
  );

  wire [64-1:0] k__in;
  wire k__in_isSingleByte;
  wire k__in_isLast;
  wire k__in_isReady;
  wire k__in_canReceive;
  wire [64-1:0] k__out;
  wire k__out_isReady;
  wire k__out_canReceive;
  wire k__out_isLast;
  wire k__cmd__secondaryNumBlocks = {{`Keccak_BlockCounterSize-1{1'b0}}, k__cmd[0]};
  wire k__cmd__mainNumBlocks = k__cmd[1+:`Keccak_BlockCounterSize];
  wire k__cmd__mainIsInElseOut = k__cmd[1+`Keccak_BlockCounterSize];
  wire k__cmd__param = k__cmd[1+`Keccak_BlockCounterSize+1+:3];
  wire [`KeccakCMD_SIZE-1:0] k__cmd__expanded = k__cmd__mainIsInElseOut ? { k__cmd__param, k__cmd__mainNumBlocks,      k__cmd__secondaryNumBlocks }
                                                                        : { k__cmd__param, k__cmd__secondaryNumBlocks, k__cmd__mainNumBlocks      };
  keccak k(
    .cmd(k__cmd__expanded),
    .cmd_isReady(k__cmd_isReady),
    .cmd_canReceive(k__cmd_canReceive),
    .in(k__in),
    .in_isSingleByte(k__in_isSingleByte),
    .in_isLast(k__in_isLast),
    .in_isReady(k__in_isReady),
    .in_canReceive(k__in_canReceive),
    .out(k__out),
    .out_isReady(k__out_isReady),
    .out_canReceive(k__out_canReceive),
    .out_isLast(k__out_isLast),
    .rst(rst),
    .clk(clk)
  );

  adapted_keccak__in k_in(
    .cmd(k_in__cmd),
    .cmd_isReady(k_in__cmd_isReady),
    .cmd_canReceive(k_in__cmd_canReceive),
    .h__out(h__out),
    .h__out_isReady(h__out_isReady),
    .h__out_canReceive(h__out_canReceive),
    .h__out_isLast_in(h__out_isLast_in),
    .h__out_isLast_out(h__out_isLast_out),
    .k__in(k__in),
    .k__in_isSingleByte(k__in_isSingleByte), 
    .k__in_isLast(k__in_isLast),
    .k__in_isReady(k__in_isReady),
    .k__in_canReceive(k__in_canReceive),
    .rst(rst),
    .clk(clk)
  );

  adapted_keccak__out k_out(
    .cmd(k_out__cmd),
    .cmd_isReady(k_out__cmd_isReady),
    .cmd_canReceive(k_out__cmd_canReceive),
    .h__in(h__in),
    .h__in_isReady(h__in_isReady),
    .h__in_canReceive(h__in_canReceive),
    .h__in_isLast_in(h__in_isLast_in),
    .h__in_isLast_out(h__in_isLast_out),
    .k__out(k__out),
    .k__out_isReady(k__out_isReady),
    .k__out_canReceive(k__out_canReceive),
    .k__out_isLast(k__out_isLast),
    .rst(rst),
    .clk(clk)
  );

endmodule
