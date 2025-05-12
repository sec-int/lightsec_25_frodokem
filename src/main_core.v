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

`include "adapted_keccak.v"
`include "busHubAndAdapters.v"
`include "memAndMul.v"
`include "seedAStorage.v"

//TODO: fix the in/out naming convention


`define CmdHubCMD_outer     4'b1000
`define CmdHubCMD_keccak    4'b0100
`define CmdHubCMD_memAndMul 4'b0010
`define CmdHubCMD_seedA     4'b0001

`define CmdHubCMD_SIZE  8

// must be the highest of OuterInCMD_SIZE, OuterOutCMD_SIZE, KeccakInCMD_SIZE, KeccakOutCMD_SIZE, CmdHubCMD_SIZE, MemAndMulCMD_SIZE, KeccakCMD_SIZE
`define MainCoreCMD_SIZE  35

`define MainCoreCMD_which_o_in  3'd0
`define MainCoreCMD_which_o_out 3'd1
`define MainCoreCMD_which_k_in  3'd2
`define MainCoreCMD_which_k_out 3'd3
`define MainCoreCMD_which_h     3'd4
`define MainCoreCMD_which_m     3'd5
`define MainCoreCMD_which_k     3'd6
`define MainCoreCMD_which_s     3'd7

`define MainCoreCMD_which_SIZE  3

// _Which and Padding for _cmd
`define MainCoreCMD_wp_o_in  { `MainCoreCMD_which_o_in,  {`MainCoreCMD_SIZE - `OuterInCMD_SIZE{1'b0}} }
`define MainCoreCMD_wp_o_out { `MainCoreCMD_which_o_out, {`MainCoreCMD_SIZE - `OuterOutCMD_SIZE{1'b0}} }
`define MainCoreCMD_wp_k_in  { `MainCoreCMD_which_k_in,  {`MainCoreCMD_SIZE - `KeccakInCMD_SIZE{1'b0}} }
`define MainCoreCMD_wp_k_out { `MainCoreCMD_which_k_out, {`MainCoreCMD_SIZE - `KeccakOutCMD_SIZE{1'b0}} }
`define MainCoreCMD_wp_h     { `MainCoreCMD_which_h,     {`MainCoreCMD_SIZE - `CmdHubCMD_SIZE{1'b0}} }
`define MainCoreCMD_wp_m     { `MainCoreCMD_which_m,     {`MainCoreCMD_SIZE - `MemAndMulCMD_SIZE{1'b0}} }
`define MainCoreCMD_wp_k     { `MainCoreCMD_which_k,     {`MainCoreCMD_SIZE - `KeccakCMD_SIZE{1'b0}} }
`define MainCoreCMD_wp_s     { `MainCoreCMD_which_s,     {`MainCoreCMD_SIZE - `SeedAStorageCMD_SIZE{1'b0}} }


// TODO: make the keccak adapter also do the split-into-1344 and merge-outof-1344 for A's Gen, and insert a repeat-1344 in the keccak
// TODO: make seedA its own module.

// TODO: reset
// TODO: name all sub-modules
// TODO: why in hell is everything missing?!
`ATTR_MOD_GLOBAL
module main_core(
    // o_in:  { sampledFromStd:1bit, size:`Outer_MaxWordLen bits }
    // o_out: { sampledToStd:1bit, size:`Outer_MaxWordLen bits }
    // k_in:  { byteVal:8bits, skipIsLast:1bit, CMD:1bit }
    // k_out: { skipIsLast:1bit, sample:1bit }
    // k:     { is128else256, inState:1bit, outState:1bit, numInBlocks:16bits, numOutBlocks:16bits }
    // h:     { destination:4bit, source:4bit }  each is: { outer:1bit, keccak:1bit, memAndMul:1bit, seedA:1bit }
    // m:     { only command:5bit }
    // s:     { cmd_startIn:1bit, cmd_startOut:1bit }
    input [`MainCoreCMD_which_SIZE+`MainCoreCMD_SIZE-1:0] cmd, // { select which destination:`MainCoreCMD_which_SIZE bits, cmd:`MainCoreCMD_SIZE bits }
    input cmd_hasAny,
    output cmd_consume,

    input [64-1:0] in,
    input in_isReady,
    output in_canReceive,

    output [64-1:0] out,
    output out_isReady,
    input out_canReceive,

    input rst,
    input clk
  );
  wor ignore;
  wire [`MainCoreCMD_SIZE-1:0] cmd_cmd = cmd[0+:`MainCoreCMD_SIZE];
  wire [`MainCoreCMD_which_SIZE-1:0] cmd_which = cmd[`MainCoreCMD_SIZE+:`MainCoreCMD_which_SIZE];

  wire o_in__cmd_canReceive;
  wire o_out__cmd_canReceive;
  wire k_in__cmd_canReceive;
  wire k_out__cmd_canReceive;
  wire h__cmd_canReceive;
  wire m__cmd_canReceive;
  wire k__cmd_canReceive;
  wire s__cmd_canReceive;
  assign cmd_canReceive = cmd_which == `MainCoreCMD_which_o_in & o_in__cmd_canReceive
                        | cmd_which == `MainCoreCMD_which_o_out & o_out__cmd_canReceive
                        | cmd_which == `MainCoreCMD_which_k_in & k_in__cmd_canReceive
                        | cmd_which == `MainCoreCMD_which_k_out & k_out__cmd_canReceive
                        | cmd_which == `MainCoreCMD_which_h & h__cmd_canReceive
                        | cmd_which == `MainCoreCMD_which_m & m__cmd_canReceive
                        | cmd_which == `MainCoreCMD_which_k & k__cmd_canReceive
                        | cmd_which == `MainCoreCMD_which_s & s__cmd_canReceive;
  assign cmd_consume = cmd_hasAny & cmd_canReceive;

  wire o_in__cmd_isReady  = cmd_which == `MainCoreCMD_which_o_in & cmd_hasAny & o_in__cmd_canReceive;
  wire o_out__cmd_isReady = cmd_which == `MainCoreCMD_which_o_out & cmd_hasAny & o_out__cmd_canReceive;
  wire k_in__cmd_isReady  = cmd_which == `MainCoreCMD_which_k_in & cmd_hasAny & k_in__cmd_canReceive;
  wire k_out__cmd_isReady = cmd_which == `MainCoreCMD_which_k_out & cmd_hasAny & k_out__cmd_canReceive;
  wire h__cmd_isReady = cmd_which == `MainCoreCMD_which_h & cmd_hasAny & h__cmd_canReceive;
  wire m__cmd_isReady = cmd_which == `MainCoreCMD_which_m & cmd_hasAny & m__cmd_canReceive;
  wire k__cmd_isReady = cmd_which == `MainCoreCMD_which_k & cmd_hasAny & k__cmd_canReceive;
  wire s__cmd_isReady = cmd_which == `MainCoreCMD_which_s & cmd_hasAny & s__cmd_canReceive;


  wire [64*4-1:0] h__in;
  wire [4-1:0] h__in_isReady;
  wire [4-1:0] h__in_canReceive;
  wire [4-1:0] h__in_isLast_in;
  wire [4-1:0] h__in_isLast_out;
  wire [64*4-1:0] h__out;
  wire [4-1:0] h__out_isReady;
  wire [4-1:0] h__out_canReceive;
  wire [4-1:0] h__out_isLast_in;
  wire [4-1:0] h__out_isLast_out;
  busSwitch #(4) hub (
    .cmd(cmd_cmd[0+:`CmdHubCMD_SIZE]),
    .cmd_isReady(h__cmd_isReady),
    .cmd_canReceive(h__cmd_canReceive),
//    .allowedCMDMask(16'b0111_1011_1100_1100), // [pos_to * N + pos_from] { outer:1bit, keccak:1bit, memAndMul:1bit, seedA:1bit }
    .allowedCMDMask(16'b1111_1011_1100_1100), // [pos_to * N + pos_from] { outer:1bit, keccak:1bit, memAndMul:1bit, seedA:1bit }
    .in(h__in),
    .in_isReady(h__in_isReady),
    .in_canReceive(h__in_canReceive),
    .in_isLast_in(h__in_isLast_in),
    .in_isLast_out(h__in_isLast_out),
    .out(h__out),
    .out_isReady(h__out_isReady),
    .out_canReceive(h__out_canReceive),
    .out_isLast_in(h__out_isLast_in),
    .out_isLast_out(h__out_isLast_out),
    .rst(rst),
    .clk(clk)
  );
  
  main_adapter_outer_in o_in(
    .cmd(cmd_cmd[0+:`OuterInCMD_SIZE]),
    .cmd_isReady(o_in__cmd_isReady),
    .cmd_canReceive(o_in__cmd_canReceive),
    .h__in(h__in[64*3+:64]),
    .h__in_isReady(h__in_isReady[3]),
    .h__in_canReceive(h__in_canReceive[3]),
    .h__in_isLast_in(h__in_isLast_in[3]),
    .h__in_isLast_out(h__in_isLast_out[3]),
    .o__in(in),
    .o__in_isReady(in_isReady),
    .o__in_canReceive(in_canReceive),
    .rst(rst),
    .clk(clk)
  );

  main_adapter_outer_out o_out(
    .cmd(cmd_cmd[0+:`OuterOutCMD_SIZE]),
    .cmd_isReady(o_out__cmd_isReady),
    .cmd_canReceive(o_out__cmd_canReceive),
    .h__out(h__out[64*3+:64]),
    .h__out_isReady(h__out_isReady[3]),
    .h__out_canReceive(h__out_canReceive[3]),
    .h__out_isLast_in(h__out_isLast_in[3]),
    .h__out_isLast_out(h__out_isLast_out[3]),
    .o__out(out),
    .o__out_isReady(out_isReady),
    .o__out_canReceive(out_canReceive),
    .rst(rst),
    .clk(clk)
  );
  
  adapted_keccak keccak(
    .k_in__cmd(cmd_cmd[0+:`KeccakInCMD_SIZE]),
    .k_in__cmd_isReady(k_in__cmd_isReady),
    .k_in__cmd_canReceive(k_in__cmd_canReceive),
    .k_out__cmd(cmd_cmd[0+:`KeccakOutCMD_SIZE]),
    .k_out__cmd_isReady(k_out__cmd_isReady),
    .k_out__cmd_canReceive(k_out__cmd_canReceive),
    .k__cmd(cmd_cmd[0+:`KeccakCMD_SIZE]),
    .k__cmd_isReady(k__cmd_isReady),
    .k__cmd_canReceive(k__cmd_canReceive),
    .h__out(h__out[2*64+:64]),
    .h__out_isReady(h__out_isReady[2]),
    .h__out_canReceive(h__out_canReceive[2]),
    .h__out_isLast_in(h__out_isLast_in[2]),
    .h__out_isLast_out(h__out_isLast_out[2]),
    .h__in(h__in[2*64+:64]),
    .h__in_isReady(h__in_isReady[2]),
    .h__in_canReceive(h__in_canReceive[2]),
    .h__in_isLast_in(h__in_isLast_in[2]),
    .h__in_isLast_out(h__in_isLast_out[2]),
    .rst(rst),
    .clk(clk)
  );

  assign ignore = h__out_isLast_out[1] | h__in_isLast_out[1];
  memAndMul memAndMul(
    .cmd(cmd_cmd[0+:`MemAndMulCMD_SIZE]),
    .cmd_isReady(m__cmd_isReady),
    .cmd_canReceive(m__cmd_canReceive),
    .in_isReady(h__out_isReady[1]),
    .in(h__out[1*64+:64]),
    .in_canReceive(h__out_canReceive[1]),
    .in_isLast(h__out_isLast_in[1]),
    .out_isReady(h__in_isReady[1]),
    .out_isLast(h__in_isLast_in[1]),
    .out(h__in[1*64+:64]),
    .out_canReceive(h__in_canReceive[1]),
    .rst(rst),
    .clk(clk)
  );

  assign ignore = h__out_isLast_out[0] | h__in_isLast_out[0];
  seedAStorage seedA(
    .cmd(cmd_cmd[0+:`SeedAStorageCMD_SIZE]),
    .cmd_isReady(s__cmd_isReady),
    .cmd_canReceive(s__cmd_canReceive),
    .in(h__out[0*64+:64]),
    .in_isReady(h__out_isReady[0]),
    .in_isLast(h__out_isLast_in[0]),
    .in_canReceive(h__out_canReceive[0]),
    .out(h__in[0*64+:64]),
    .out_isReady(h__in_isReady[0]),
    .out_isLast(h__in_isLast_in[0]),
    .out_canReceive(h__in_canReceive[0]),
    .rst(rst),
    .clk(clk)
  );
endmodule

