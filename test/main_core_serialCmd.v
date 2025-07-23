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


// max of `OuterInCMD_SIZE, `OuterOutCMD_SIZE, `KeccakInCMD_SIZE, `KeccakOutCMD_SIZE, `CmdHubCMD_SIZE, `MemAndMulCMD_SIZE, `KeccakAdaptedCMD_SIZE, `SeedAStorageCMD_SIZE
`define MainCoreSerialCMD_SIZE  15

// _Which and Padding for _cmd
`define MainCoreSerialCMD_wp_o_in  { `MainCoreCMD_which_o_in,  {`MainCoreSerialCMD_SIZE - `OuterInCMD_SIZE{1'b0}} }
`define MainCoreSerialCMD_wp_o_out { `MainCoreCMD_which_o_out, {`MainCoreSerialCMD_SIZE - `OuterOutCMD_SIZE{1'b0}} }
`define MainCoreSerialCMD_wp_k_in  { `MainCoreCMD_which_k_in,  {`MainCoreSerialCMD_SIZE - `KeccakInCMD_SIZE{1'b0}} }
`define MainCoreSerialCMD_wp_k_out { `MainCoreCMD_which_k_out, {`MainCoreSerialCMD_SIZE - `KeccakOutCMD_SIZE{1'b0}} }
`define MainCoreSerialCMD_wp_h     { `MainCoreCMD_which_h,     {`MainCoreSerialCMD_SIZE - `CmdHubCMD_SIZE{1'b0}} }
`define MainCoreSerialCMD_wp_m     { `MainCoreCMD_which_m,     {`MainCoreSerialCMD_SIZE - `MemAndMulCMD_SIZE{1'b0}} }
`define MainCoreSerialCMD_wp_k     { `MainCoreCMD_which_k,     {`MainCoreSerialCMD_SIZE - `KeccakAdaptedCMD_SIZE{1'b0}} }
`define MainCoreSerialCMD_wp_s     { `MainCoreCMD_which_s,     {`MainCoreSerialCMD_SIZE - `SeedAStorageCMD_SIZE{1'b0}} }

module main_core_serialCmd(
    input [`MainCoreCMD_which_SIZE+`MainCoreSerialCMD_SIZE-1:0] cmd,
    input cmd_hasAny,
    output cmd_consume,

    input [64-1:0] in,
    input in_isReady,
    output in_canReceive,

    output [64-1:0] out,
    output out_isReady,
    input out_canReceive,

    input [`MainCoreCONF_SIZE-1:0] conf, // { The FrodoKEM parameter/8 : 8bits, which sampling distribution : 3bits }.

    input rst,
    input clk
  );

  wire [`MainCoreCMD_which_SIZE-1:0] core__cmd_hasAny = cmd[`MainCoreCMD_which_SIZE+`MainCoreSerialCMD_SIZE-1-:`MainCoreCMD_which_SIZE];
  wire [`MainCoreCMD_SIZE-1:0] core__cmd = {
    cmd[0+:`OuterInCMD_SIZE],
    cmd[0+:`OuterOutCMD_SIZE],
    cmd[0+:`KeccakInCMD_SIZE],
    cmd[0+:`KeccakOutCMD_SIZE],
    cmd[0+:`CmdHubCMD_SIZE],
    cmd[0+:`MemAndMulCMD_SIZE],
    cmd[0+:`KeccakAdaptedCMD_SIZE],
    cmd[0+:`SeedAStorageCMD_SIZE]
  };

  main_core core(
    .cmd(core__cmd),
    .cmd_hasAny(core__cmd_hasAny),
    .cmd_consume(cmd_consume),
    .in(in),
    .in_isReady(in_isReady),
    .in_canReceive(in_canReceive),
    .out(out),
    .out_isReady(out_isReady),
    .out_canReceive(out_canReceive),
    .conf(conf),
    .rst(rst),
    .clk(clk)
  );
endmodule

