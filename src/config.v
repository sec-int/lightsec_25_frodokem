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

`ifndef CONFIG_V
`define CONFIG_V


// uncomment to enable:
//
//`define USE_DONT_TOUCH
//`define USE_BRAM_IP
//`define USE_NO_KECCAK
//`define USE_NO_KECCAK_PERMUTATION




`ifdef USE_DONT_TOUCH
`define ATTR_MOD_GLOBAL (* DONT_TOUCH = "yes" *)
`else
`define ATTR_MOD_GLOBAL
`endif


`endif // LIB_V


