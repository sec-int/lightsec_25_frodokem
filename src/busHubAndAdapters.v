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

`include "lib.v"


module busSwitch #(parameter N = 1) (
    input [N*2-1:0] cmd, // more than one can be selected at the same time, but with only one source. lowest bits are the source, the highest ones are destination.
    input cmd_isReady,
    output cmd_canReceive,
    input [N*N-1:0] allowedCMDMask,

    // the _isLast of connected streams must match if present.

    input [64*N-1:0] in,
    input [N-1:0] in_isReady,
    output [N-1:0] in_canReceive,
    input [N-1:0] in_isLast_in,
    output [N-1:0] in_isLast_out,

    output [64*N-1:0] out,
    output [N-1:0] out_isReady,
    input [N-1:0] out_canReceive,
    input [N-1:0] out_isLast_in,
    output [N-1:0] out_isLast_out,

    input rst,
    input clk
  );
  wire [N*2-1:0] cmdB;
  wire cmdB_hasAny;
  wire cmdB_consume;
  bus_delay_fromstd1 #(.BusSize(N*2)) cmdBuf (
    .i(cmd),
    .i_isReady(cmd_isReady),
    .i_canReceive(cmd_canReceive),
    .o(cmdB),
    .o_hasAny(cmdB_hasAny),
    .o_consume(cmdB_consume),
    .rst(rst),
    .clk(clk)
  );

  genvar pos_from;
  genvar pos_to;

  wire [N*N-1:0] p2p__d1;
  wor [N*2-1:0] cumulativeCmd__d1;
  generate
    for(pos_from = 0; pos_from < N; pos_from=pos_from+1) begin
      for(pos_to = 0; pos_to < N; pos_to=pos_to+1) begin
        assign cumulativeCmd__d1[pos_to + N] = p2p__d1[pos_to*N + pos_from];
        assign cumulativeCmd__d1[pos_from] = p2p__d1[pos_to*N + pos_from];
      end
    end
  endgenerate

  wire cmdB_wait = | (cmdB & cumulativeCmd__d1);
  assign cmdB_consume = cmdB_hasAny & ~cmdB_wait;

  wire [N-1:0] p2p_reset_byFrom;
  wire [N*N-1:0] p2p;
  generate
    for(pos_from = 0; pos_from < N; pos_from=pos_from+1) begin
      for(pos_to = 0; pos_to < N; pos_to=pos_to+1) begin
        assign p2p[pos_to * N + pos_from] = p2p__d1[pos_to*N + pos_from] & ~p2p_reset_byFrom[pos_from]
                                          | allowedCMDMask[pos_to*N + pos_from] & cmdB_consume & cmdB[pos_to + N] & cmdB[pos_from];
      end
    end
  endgenerate
  delay #(N*N) p2p__ff (p2p, p2p__d1, rst, clk);

  wor [N-1:0] inAny;
  wor [64*N-1:0] out__w;
  wor [N-1:0] out_isReady__w;
  wand [N-1:0] in_canReceive__w;
  wor [N-1:0] in_isLast_out__w;
  wor [N-1:0] out_isLast_out__w;
  assign out = out__w;
  assign out_isReady = out_isReady__w;
  assign in_canReceive = in_canReceive__w & inAny;
  assign in_isLast_out = in_isLast_out__w;
  assign out_isLast_out = out_isLast_out__w;
  generate
    for(pos_from = 0; pos_from < N; pos_from=pos_from+1) begin
      assign in_isLast_out__w[pos_from] = in_isLast_in[pos_from] & in_isReady[pos_from];
      assign out_isLast_out__w[pos_from] = out_isLast_in[pos_from] & out_canReceive[pos_from];

      for(pos_to = 0; pos_to < N; pos_to=pos_to+1) begin
        assign inAny[pos_from] = p2p[pos_to*N + pos_from];
        assign in_isLast_out__w[pos_from] = p2p[pos_to*N + pos_from] & out_isLast_in[pos_to] & out_canReceive[pos_to];
        assign out_isLast_out__w[pos_to] = p2p[pos_to*N + pos_from] & in_isLast_out__w[pos_from];
        assign out__w[pos_to*64+:64] = p2p[pos_to*N + pos_from] ? in[pos_from*64+:64] : {64'b0};
        assign out_isReady__w[pos_to] = p2p[pos_to*N + pos_from] & in_isReady[pos_from];
        assign in_canReceive__w[pos_from] = ~p2p[pos_to*N + pos_from] | out_canReceive[pos_to];
      end
    end
  endgenerate

  delay #(N) p2p_reset_byFrom__ff (in_isLast_out__w, p2p_reset_byFrom, rst, clk);
endmodule

`define Outer_MaxWordLen  15

`define OuterInCMD_SIZE  (`Outer_MaxWordLen)




module main_adapter_outer_out(
    input [`OuterInCMD_SIZE-1:0] cmd, //  {size:`Outer_MaxWordLen bits}  // size of 0 for automatic
    input cmd_isReady,
    output cmd_canReceive,

    input [64-1:0] h__out,
    input h__out_isReady,
    output h__out_canReceive,
    output h__out_isLast_in,
    input h__out_isLast_out,

    output [64-1:0] o__out,
    output o__out_isReady,
    input o__out_canReceive,

    input rst,
    input clk
  );
  wor ignore = h__out_isLast_out;
  wire cmd_forward = cmd_isReady; // the only primary command
  wire [`Outer_MaxWordLen-1:0] cmd_size = cmd[0+:`Outer_MaxWordLen]; // number of bus messages

  assign o__out = h__out;

  wire useCounter;
  wire useCounter__d1;
  wire useCounter__val = cmd_size != 0;
  ff_en_imm useCounter__ff1(cmd_forward, useCounter__val, useCounter, rst, clk);
  delay useCounter__ff2(useCounter, useCounter__d1, rst, clk);

  wire counter__canRestart;
  wire counter__canReceive;
  wire counter__isReady = h__out_isReady & counter__canReceive;
  counter_bus #(`Outer_MaxWordLen) counter (
    .restart(cmd_forward),
    .numSteps(cmd_size),
    .canRestart(counter__canRestart),
    .canReceive(counter__canReceive),
    .canReceive_isLast(h__out_isLast_in),
    .isReady(counter__isReady),
    .rst(rst),
    .clk(clk)
  );

  wire noCounterOngoing;
  ff_rs_next noCounterEnded__ff(h__out_isLast_out, cmd_forward, noCounterOngoing, rst, clk);

  assign cmd_canReceive = useCounter__d1 ? counter__canRestart : ~noCounterOngoing;
  assign h__out_canReceive = o__out_canReceive & (useCounter ? counter__canReceive : noCounterOngoing);
  assign o__out_isReady = h__out_isReady;
endmodule

`define OuterOutCMD_SIZE  (`Outer_MaxWordLen)



module main_adapter_outer_in(
    input [`OuterOutCMD_SIZE-1:0] cmd,  //  {size:`Outer_MaxWordLen bits}   // size of 0 means automatic
    input cmd_isReady,
    output cmd_canReceive,

    output [64-1:0] h__in,
    output h__in_isReady,
    input h__in_canReceive,
    output h__in_isLast_in,
    input h__in_isLast_out,

    input [64-1:0] o__in,
    input o__in_isReady,
    output o__in_canReceive,

    input rst,
    input clk
  );
  wor ignore = h__in_isLast_out;

  wire cmd_forward = cmd_isReady; // the only primary command
  wire [`Outer_MaxWordLen-1:0] cmd_size = cmd[0+:`Outer_MaxWordLen]; // number of bus messages

  assign h__in = o__in;


  wire useCounter;
  wire useCounter__d1;
  wire useCounter__val = cmd_size != 0;
  ff_en_imm useCounter__ff1(cmd_forward, useCounter__val, useCounter, rst, clk);
  delay useCounter__ff2(useCounter, useCounter__d1, rst, clk);

  wire counter__canRestart;
  wire counter__canReceive;
  wire counter__isReady = o__in_isReady & counter__canReceive;
  counter_bus #(`Outer_MaxWordLen) counter (
    .restart(cmd_forward),
    .numSteps(cmd_size),
    .canRestart(counter__canRestart),
    .canReceive(counter__canReceive),
    .canReceive_isLast(h__in_isLast_in),
    .isReady(counter__isReady),
    .rst(rst),
    .clk(clk)
  );

  wire noCounterOngoing;
  ff_rs_next noCounterEnded__ff(h__in_isLast_out, cmd_forward, noCounterOngoing, rst, clk);

  assign cmd_canReceive = useCounter__d1 ? counter__canRestart : ~noCounterOngoing;
  assign o__in_canReceive = h__in_canReceive & (useCounter ? counter__canReceive : noCounterOngoing);
  assign h__in_isReady = o__in_isReady;
endmodule




