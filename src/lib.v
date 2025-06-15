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

`ifndef LIB_V
`define LIB_V

`include "config.v"


`ATTR_MOD_GLOBAL
module delay #(parameter N = 1) (
  input [N-1:0] in,
  output [N-1:0] out,
  input rst,
  input clk
);
  reg [N-1:0] r;
  always @ (posedge clk) begin
    r <= rst ? {N{1'b0}} : in;
  end
  assign out = r;  
endmodule

`ATTR_MOD_GLOBAL
module optionalDelay #(parameter N = 1) (
  input doDelay,
  input [N-1:0] in,
  output [N-1:0] out,
  input rst,
  input clk
);
  wire [N-1:0] in__d1;
  delay #(N) in__ff (in, in__d1, rst, clk);
  assign out = doDelay ? in__d1 : in;
endmodule

`ATTR_MOD_GLOBAL
module ff_en_next #(parameter N = 1) (
  input enable,
  input [N-1:0] newVal,
  output [N-1:0] val,
  input rst,
  input clk
);
  wire [N-1:0] val__a1 = enable ? newVal : val;
  delay #(N) val__ff (val__a1, val, rst, clk);
endmodule

`ATTR_MOD_GLOBAL
module ff_en_imm #(parameter N = 1) (
  input enable,
  input [N-1:0] newVal,
  output [N-1:0] val,
  input rst,
  input clk
);
  wire [N-1:0] val__d1;
  assign val = enable ? newVal : val__d1;
  delay #(N) val__ff (val, val__d1, rst, clk);
endmodule

`ATTR_MOD_GLOBAL
module ff_sr_next (
  input set,
  input reset,
  output val,
  input rst,
  input clk
);
  wire val__a1 = set   ? 1'b1
               : reset ? 1'b0
                       : val;
  delay val__ff (val__a1, val, rst, clk);
endmodule

`ATTR_MOD_GLOBAL
module ff_sr_imm (
  input set,
  input reset,
  output val,
  input rst,
  input clk
);
  wire val__d1;
  assign val = set   ? 1'b1
             : reset ? 1'b0
                     : val__d1;
  delay val__ff (val, val__d1, rst, clk);
endmodule

`ATTR_MOD_GLOBAL
module ff_rs_next (
  input reset,
  input set,
  output val,
  input rst,
  input clk
);
  wire val__a1 = reset ? 1'b0
               : set   ? 1'b1
                       : val;
  delay val__ff (val__a1, val, rst, clk);
endmodule

`ATTR_MOD_GLOBAL
module ff_rs_imm (
  input reset,
  input set,
  output val,
  input rst,
  input clk
);
  wire val__d1;
  assign val = reset ? 1'b0
             : set   ? 1'b1
                     : val__d1;
  delay val__ff (val, val__d1, rst, clk);
endmodule

`ATTR_MOD_GLOBAL
module ff_s_r ( // set immediate, reset while going into the next cycle
  input set,
  input reset,
  output val,
  output preSet, // the values before the set
  input rst,
  input clk
);
  assign val = preSet | set;
  wire preSet__a1 = val &~ reset;
  delay preSet__ff (preSet__a1, preSet, rst, clk);
endmodule

`ATTR_MOD_GLOBAL
module counter_bus #(parameter N = 1) ( // N bits must be able to store the highest 'numSteps', and at least 1.
    input restart,  // can't interupt
    input [N-1:0] numSteps,
    output canRestart,
    output canReceive,
    output canReceive_wouldBeLast,
    output canReceive_isLast,
    input isReady, // it requires canReceive, as usual.

    input rst,
    input clk
  );
  wire [N-1:0] nextCounter;
  assign canRestart = nextCounter == 0;
  wire doRestart = restart & canRestart;

  wire [N-1:0] counter = doRestart ? numSteps : nextCounter;
  wire [N-1:0] counter__min1 = counter - 1;
  assign canReceive = counter != 0;
  assign canReceive_wouldBeLast = counter__min1 == 0;
  assign canReceive_isLast = counter__min1 == 0 & isReady;

  wire [N-1:0] nextCounter__a1 = isReady ? counter__min1 : counter;
  delay #(N) nextCounter__ff (nextCounter__a1, nextCounter, rst, clk);
endmodule


`ATTR_MOD_GLOBAL
module counter_bus_fixed #(parameter NUM_STEPS = 1) ( // N bits must be able to store the highest  restart_steps+1
    input restart,  // can't interupt
    output canRestart,
    output canReceive,
    output canReceive_wouldBeLast,
    output canReceive_isLast,
    input isReady, // it requires canReceive, as usual.

    input rst,
    input clk
  );
  counter_bus #($clog2(NUM_STEPS+1)) actualCounter (
    .restart(restart),  // can't interupt
    .numSteps(NUM_STEPS),
    .canRestart(canRestart),
    .canReceive(canReceive),
    .canReceive_wouldBeLast(canReceive_wouldBeLast),
    .canReceive_isLast(canReceive_isLast),
    .isReady(isReady),
    .rst(rst),
    .clk(clk)
  );
endmodule

`ATTR_MOD_GLOBAL
module counter_bus_diff #(parameter N = 1) ( // N bits must be able to store the highest 'numSteps', and at least 1.
    input restart,
    input [N-1:0] numSteps,
    output restart_consume,
    output canReceive,
    output canReceive_isLast,
    input isReady, // it requires canReceive, as usual.

    input rst,
    input clk
  );
  assign restart_consume = canReceive & canReceive_isLast & isReady;
  counter_bus #(N) actualCounter (
    .restart(restart),  // can't interupt
    .numSteps(numSteps),
    .canReceive(canReceive),
    .canReceive_isLast(canReceive_isLast),
    .isReady(isReady),
    .rst(rst),
    .clk(clk)
  );
endmodule

`ATTR_MOD_GLOBAL
module counter_bus_state #(parameter MAX_NUM_STEPS = 1) (
    input restart,  // can't interupt
    input [$clog2(MAX_NUM_STEPS+1)-1:0] numStates, // must be active throughtout the whole counter operation.
    output canRestart,
    
    output hasAny,
    output [MAX_NUM_STEPS-1:0] state, // meaningful if hasAny
    input consume, // it requires hasAny, as usual.
    output isLast,

    input rst,
    input clk
  );

  wire [MAX_NUM_STEPS-1:0] one = { {MAX_NUM_STEPS-1{1'b0}} , 1'b1};
  wire [MAX_NUM_STEPS-1:0] maskAllowedStates = (one << numStates) - one;
  
  wire [MAX_NUM_STEPS-1:0] stateNext__d1;
  assign canRestart = ~ ( | stateNext__d1 );

  assign state = stateNext__d1 | { {MAX_NUM_STEPS-1{1'b0}} , restart & canRestart};
  assign hasAny = | state;

  wire [MAX_NUM_STEPS-1:0] stateNext = consume ? (state << 1) & maskAllowedStates : state;
  assign isLast = hasAny & ~ ( | stateNext );
  delay #(MAX_NUM_STEPS) stateNext__ff (stateNext, stateNext__d1, rst, clk);
  
endmodule

`ATTR_MOD_GLOBAL
module serdes #(parameter N = 1) ( // the startSer and startDes can be true together
  input cmd_startDes,
  input cmd_startSer,
  output cmd_canReceive,

  output [64*N-1:0] buffer_write,
  input [64*N-1:0] buffer_read,

  input [64-1:0] des,
  input des_isReady,
  output des_canReceive,
  output des_isLast,
  
  output [64-1:0] ser,
  output ser_isReady,
  input ser_canReceive,
  output ser_isLast,

  input rst,
  input clk
);
  wire cmd_startAny = cmd_canReceive & (cmd_startSer | cmd_startDes);

  wire isSer, isDes;
  ff_en_imm isSer__ff (cmd_startAny, cmd_startSer, isSer, rst, clk);
  ff_en_imm isDes_ff (cmd_startAny, cmd_startDes, isDes, rst, clk);

  wire counter__canReceive;
  wire counter__isReady = counter__canReceive & (isDes ? des_isReady : ser_canReceive);
  assign ser_isLast = des_isLast;
  counter_bus_fixed #(N) counter (
    .restart(cmd_startAny),
    .canRestart(cmd_canReceive),
    .canReceive(counter__canReceive),
    .canReceive_isLast(des_isLast),
    .isReady(counter__isReady),
    .rst(rst),
    .clk(clk)
  );

  assign des_canReceive = isDes & counter__canReceive & (isSer ? ser_canReceive : 1'b1);
  assign ser_isReady = isSer & counter__canReceive & (isDes ? des_isReady : ser_canReceive);

  assign ser = buffer_read[64-1:0];
  assign buffer_write = ~counter__isReady ? buffer_read
                      : isDes             ? {des,                 buffer_read[64*N-1:64]}
                                          : {buffer_read[64-1:0], buffer_read[64*N-1:64]};
endmodule

`ATTR_MOD_GLOBAL
module cmd_buffer #(parameter CmdSize = 1, parameter BufSize = 2) (
  input [CmdSize-1:0] i,
  input i_isReady,
  output i_canReceive,

  output [CmdSize-1:0] o,
  output o_hasAny,
  input o_consume,

  input rst,
  input clk
);
  wire [BufSize-1:0] buffer_isUsed;
  wire [CmdSize*BufSize-1:0] buffer;

  assign o_hasAny = buffer_isUsed[0];
  assign o = buffer[0+:CmdSize];
  
  assign i_canReceive = ~buffer_isUsed[BufSize-1] | o_consume;
  wire [BufSize-1:0] buffer_isUsed__postConsume = buffer_isUsed >> o_consume * 1;
  wire [CmdSize*BufSize-1:0] buffer__postConsume = buffer >> o_consume * CmdSize;

  wire [BufSize-1:0] whereToInsert = i_isReady ? (buffer_isUsed__postConsume << 1 | 1'b1) & ~buffer_isUsed__postConsume : {BufSize{1'b0}};
//  wire [BufSize-1:0] whereToInsert = { buffer_isUsed__postConsume[0+:BufSize-1], 1'b1 } & ~buffer_isUsed__postConsume;

  wire [BufSize-1:0] buffer_isUsed__a1 = buffer_isUsed__postConsume | whereToInsert;
  wor [CmdSize*BufSize-1:0] buffer__a1 = buffer__postConsume;
  genvar pos;
  generate
    for (pos = 0; pos < BufSize; pos=pos+1) begin
      assign buffer__a1[pos*CmdSize+:CmdSize] = whereToInsert[pos] ? i : {CmdSize{1'b0}};
    end
  endgenerate

  delay #(CmdSize*BufSize) buffer__ff (buffer__a1, buffer, rst, clk);
  delay #(BufSize) buffer_isUsed__ff (buffer_isUsed__a1, buffer_isUsed, rst, clk);
endmodule

`ATTR_MOD_GLOBAL
module cmd_buffer_std #(parameter CmdSize = 1, parameter BufSize = 2) (
  input [CmdSize-1:0] i,
  input i_isReady,
  output i_canReceive,

  output [CmdSize-1:0] o,
  output o_isReady,
  input o_canReceive,

  input rst,
  input clk
);
  wire o_hasAny;
  wire o_consume = o_hasAny & o_canReceive;
  assign o_isReady = o_hasAny & o_canReceive;
  cmd_buffer #(CmdSize, BufSize) actualBuffer (
    .i(i),
    .i_isReady(i_isReady),
    .i_canReceive(i_canReceive),
    .o(o),
    .o_hasAny(o_hasAny),
    .o_consume(o_consume),
    .rst(rst),
    .clk(clk)
  );
endmodule

`ATTR_MOD_GLOBAL
module cmd_buffer_unstd #(parameter CmdSize = 1, parameter BufSize = 2) (
  input [CmdSize-1:0] i,
  input i_hasAny,
  output i_consume,

  output [CmdSize-1:0] o,
  output o_hasAny,
  input o_consume,

  input rst,
  input clk
);
  wire i_canReceive;
  assign i_consume = i_hasAny & i_canReceive;
  wire i_isReady = i_hasAny & i_canReceive;
  cmd_buffer #(CmdSize, BufSize) actualBuffer (
    .i(i),
    .i_isReady(i_isReady),
    .i_canReceive(i_canReceive),
    .o(o),
    .o_hasAny(o_hasAny),
    .o_consume(o_consume),
    .rst(rst),
    .clk(clk)
  );
endmodule

`ATTR_MOD_GLOBAL
module cmd_buffer1 #(parameter CmdSize = 1) (
  input [CmdSize-1:0] i,
  input i_isReady,
  output i_canReceive,

  output [CmdSize-1:0] o,
  output o_hasAny,
  input o_consume,

  input rst,
  input clk
);
  wire buffer_isUsed;
  wire [CmdSize-1:0] buffer;

  assign o = buffer;
  assign o_hasAny = buffer_isUsed;

  assign i_canReceive = ~buffer_isUsed | o_consume;
  wire buffer_isUsed__postConsume        = o_consume ?    1'b0         : buffer_isUsed;
  wire [CmdSize-1:0] buffer__postConsume = o_consume ? {CmdSize{1'b0}} : buffer;

  wire buffer_isUsed__a1        = buffer_isUsed__postConsume |  i_isReady;
  wire [CmdSize-1:0] buffer__a1 = buffer__postConsume        | (i_isReady ? i : {CmdSize{1'b0}});

  delay #(CmdSize) buffer__ff (buffer__a1, buffer, rst, clk);
  delay buffer_isUsed__ff (buffer_isUsed__a1, buffer_isUsed, rst, clk);
endmodule

`endif // LIB_V


