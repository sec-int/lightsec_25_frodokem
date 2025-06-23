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
`include "frodoMul.v"
`include "mem.v"

// TODO: MemAndMulCMD_inOp_CpleqStimesInB: the index2's initial reset is done too late


`define MemAndMulIndexCMD_in               5'h01
`define MemAndMulIndexCMD_out              5'h02
`define MemAndMulIndexCMD_updateSync       5'h04 /* Read from one var and write to another, with same indexes. */
`define MemAndMulIndexCMD_updateSyncIn     5'h08 /* Read from one var and write to another, with same indexes. Using a variable from input */
`define MemAndMulIndexCMD_updateSyncMem    5'h0C /* Read from two vars and write to another, all with same indexes, */
`define MemAndMulIndexCMD_updateSlowMemIn  5'h10 /* Read from one vars and write to another, with same indexes, using a variable from input. Before this, read the next of another variable and repeat. */
`define MemAndMulIndexCMD_updateFastMemIn  5'h14 /* read from one var and write to another, with same indexes, In between, read another variable and the input. */
`define MemAndMulIndexCMD_updateFastMemMem 5'h18 /* read from one var and write to another, with same indexes, In between, read two variables, with the second's index a combination of the other two */

`define MemAndMulIndexCMD_SIZE 5

`ATTR_MOD_GLOBAL
module memAndMul__indexHandler(
    input [`MemAndMulIndexCMD_SIZE-1:0] currentCmd,
    input currentCmd_in_isFirstCycle,
    input currentCmd_out_isFirstCycle,
    output currentCmd_in_isLastCycle,
    output currentCmd_out_isLastCycle, // the bus_out__d2 can output after this is active as this is to start new commands

    input bus_inOp_isReady,
    output bus_inOp_canReceive,
    output bus_inOp_isLast,
    input bus_in_isReady,
    input bus_out_canReceive,

    output [14-1:0] r_index,
    input [14-1:0] r_index_next,
    input r_index_hasNext,
    output [14-1:0] w_index,
    input [14-1:0] w_index_next,
    input w_index_hasNext,

    output r_index__useIndex1,
    output index1__toggle,
    output r_enable,
    output r_enable__d2,
    output w_enable,

    input rst,
    input clk
  );

  wire currentCmd_in = (currentCmd & `MemAndMulIndexCMD_in) != 0;
  wire currentCmd_out = (currentCmd & `MemAndMulIndexCMD_out) != 0;
  wire currentCmd_updateSync = currentCmd == `MemAndMulIndexCMD_updateSync;
  wire currentCmd_updateSyncIn = currentCmd == `MemAndMulIndexCMD_updateSyncIn;
  wire currentCmd_updateSyncMem = currentCmd == `MemAndMulIndexCMD_updateSyncMem;
  wire currentCmd_updateSlowMemIn = currentCmd == `MemAndMulIndexCMD_updateSlowMemIn;
  wire currentCmd_updateFastMemIn = currentCmd == `MemAndMulIndexCMD_updateFastMemIn;
  wire currentCmd_updateFastMemMem = currentCmd == `MemAndMulIndexCMD_updateFastMemMem;

  wire currentCmd_updateSyncAny = currentCmd_updateSync || currentCmd_updateSyncIn || currentCmd_updateSyncMem;
  wire currentCmd_updateFSAnyIn = currentCmd_updateFastMemIn || currentCmd_updateSlowMemIn;
  wire currentCmd_updateFSAny = currentCmd_updateFSAnyIn || currentCmd_updateFastMemMem;
  wire currentCmd_updateFastAny = currentCmd_updateFastMemIn || currentCmd_updateFastMemMem;
  wire currentCmd_updateAnyIn = currentCmd_updateSyncIn || currentCmd_updateFSAnyIn;
  wire currentCmd_updateAnyMem = currentCmd_updateSyncMem || currentCmd_updateFastMemMem;


  // index1 is: read or the only one or fast
  // index2 is: write or             or slow


  // index reset
  wire currentCmd_in_isFirstCycle__d1;
  delay currentCmd_in_isFirstCycle__ff1 (currentCmd_in_isFirstCycle, currentCmd_in_isFirstCycle__d1, rst, clk);

  wire index1_isLast__d2;
  wire index1_reset = (currentCmd_out & currentCmd_out_isFirstCycle)
                    | (currentCmd_updateSyncAny & currentCmd_in_isFirstCycle)
                    | (currentCmd_updateFSAny & (currentCmd_in_isFirstCycle__d1 | index1_isLast__d2));
  wire index2_reset = (currentCmd_in & currentCmd_in_isFirstCycle)
                    | (currentCmd_updateFSAny & currentCmd_in_isFirstCycle);


  // index update
  wire index1__toggle__d1;
  assign index1__toggle = index1_reset ? 1'b0 : ~index1__toggle__d1;
  delay index1__toggle__ff(index1__toggle, index1__toggle__d1, rst, clk);

  wire index1_reset__d1;
  delay index1_reset__ff(index1_reset, index1_reset__d1, rst, clk);
  wire index1_has_next;
  wire index1_has_next__d1;
  delay index1_has_next__ff1 (index1_has_next, index1_has_next__d1, rst, clk);
  wire index1_has_next__d2;
  delay index1_has_next__ff2 (index1_has_next__d1, index1_has_next__d2, rst, clk);
  wire index1_has_val__a1 = index1_has_next; // in theory it needs to be '| index1_reset__a1' but we're only using this to create the '_isLast' and we never have a value with a single cell.
  wire index1_has_val = index1_reset | index1_has_next__d1;
  wire index1_has_val__d1;
  delay index1_has_val__ff1 (index1_has_val, index1_has_val__d1, rst, clk);
  wire index1_has_val__d2;
  delay index1_has_val__ff2 (index1_has_val__d1, index1_has_val__d2, rst, clk);
  wire index1_isLast = index1_has_val & ~index1_has_val__a1;
  wire index1_isLast__d1 = index1_has_val__d1 & ~index1_has_val;
  assign index1_isLast__d2 = index1_has_val__d2 & ~index1_has_val__d1;

  wire index2_has_next;
  wire index2_has_next__d1;
  delay index2_has_next__ff(index2_has_next, index2_has_next__d1, rst, clk);
  wire index2_has_val = index2_reset | index2_has_next__d1;

  wire index1_update = currentCmd_out & bus_out_canReceive
                     | currentCmd_updateAnyMem & index1__toggle
                     | currentCmd_updateAnyIn & bus_inOp_isReady
                     | currentCmd_updateSync;
  wire index2_update = currentCmd_in & bus_in_isReady
                     | currentCmd_updateFSAny & index1_isLast;


  // indexes
  wire [14-1:0] index1_next_input = r_index_next;
  wire [14-1:0] index2_next_input = currentCmd_in | currentCmd_updateFastAny ? w_index_next : r_index_next;

  wire [14-1:0] index1_next__d1;
  wire [14-1:0] index1 = index1_reset ? 14'b0 : index1_next__d1;
  wire [14-1:0] index1_next = index1_update & index1_has_next ? index1_next_input : index1;
  delay #(14) index1_next__ff (index1_next, index1_next__d1, rst, clk);
  wire [14-1:0] index2_next__d1;
  wire [14-1:0] index2 = index2_reset ? 14'b0 : index2_next__d1;
  wire [14-1:0] index2_next = index2_update & index2_has_next ? index2_next_input : index2;
  delay #(14) index2_next__ff (index2_next, index2_next__d1, rst, clk);


  // _isLastCycle
  wire index2_update__d1;
  delay index2_update__ff (index2_update, index2_update__d1, rst, clk);

  assign index1_has_next = index1_reset | (~index1_update ? index1_has_next__d1 : r_index_hasNext);
  assign index2_has_next = index2_reset | (~(currentCmd_updateFastAny ? index2_update__d1 : index2_update) ? index2_has_next__d1 : (currentCmd_in ? w_index_hasNext : r_index_hasNext));

  wire currentCmd_op_isLastCycle__a2 = currentCmd_updateSyncMem & index1__toggle & ~index1_has_next
                                     | currentCmd_updateSyncIn & bus_inOp_isReady & ~index1_has_next
                                     | currentCmd_updateSync & ~index1_has_next
                                     | currentCmd_updateFSAny & ~(index1_has_next | index1_has_next__d1 | index2_has_next | index2_has_next__d1); // TODO: do we need to check bus_inOp_isReady?
  wire currentCmd_op_isLastCycle__a1;
  delay currentCmd_op_isLastCycle__ff2 (currentCmd_op_isLastCycle__a2, currentCmd_op_isLastCycle__a1, rst, clk);
  wire currentCmd_op_isLastCycle;
  delay currentCmd_op_isLastCycle__ff1 (currentCmd_op_isLastCycle__a1, currentCmd_op_isLastCycle, rst, clk);
  assign currentCmd_in_isLastCycle = currentCmd_in ? bus_in_isReady & ~w_index_hasNext : currentCmd_op_isLastCycle;
  assign currentCmd_out_isLastCycle = currentCmd_out ? bus_out_canReceive & ~r_index_hasNext : currentCmd_op_isLastCycle;
  
  // bus_inOp_
  assign bus_inOp_canReceive = (currentCmd_updateSyncIn | currentCmd_updateFSAnyIn) & index1_has_val;
  assign bus_inOp_isLast = currentCmd_updateFastMemIn ? index1_has_val & ~index1_has_next & ~index2_has_next
                                                      : currentCmd_op_isLastCycle__a2;

  // r index
  assign r_index__useIndex1 = currentCmd_out | currentCmd_updateSyncAny | (currentCmd_updateFSAny & index1_has_val);
  assign r_index = ~r_index__useIndex1                          ? index2
                 : currentCmd_updateFastMemMem & index1__toggle ? { index2[0+:5], index1[0+:9] }
                                                                : index1;

  wire r_enable_op = currentCmd_updateFastMemMem & (index1_has_val | index2_has_val)
                   | currentCmd_updateFastMemIn  & (index1_has_val & bus_inOp_isReady | index2_has_val)
                   | currentCmd_updateSlowMemIn  & (index1_has_val & bus_inOp_isReady | index2_has_val)
                   | currentCmd_updateSyncMem    & index1_has_val
                   | currentCmd_updateSyncIn     & index1_has_val & bus_inOp_isReady
                   | currentCmd_updateSync       & index1_has_val;
  assign r_enable = currentCmd_out & bus_out_canReceive
                  | r_enable_op;
  wire r_enable__d1;
  delay r_enable_op__ff1 (r_enable, r_enable__d1, rst, clk);
  delay r_enable_op__ff2 (r_enable__d1, r_enable__d2, rst, clk);

  // w_enable
  wire w_enable_op__a2 = currentCmd_updateFastMemIn  & index1_isLast__d1
                       | currentCmd_updateFastMemMem & index1_isLast__d1
                       | currentCmd_updateSyncMem    & index1__toggle & index1_has_val
                       | currentCmd_updateSyncIn     & bus_inOp_isReady
                       | currentCmd_updateSync       & index1_has_val
                       | currentCmd_updateSlowMemIn  & bus_inOp_isReady;
  wire w_enable_op__a1;
  delay w_enable_op__ff2 (w_enable_op__a2, w_enable_op__a1, rst, clk);
  wire w_enable_op;
  delay w_enable_op__ff1 (w_enable_op__a1, w_enable_op, rst, clk);
  assign w_enable = currentCmd_in & bus_in_isReady
                  | w_enable_op;

  // w index
  wire [14-1:0] index2__d1;
  delay #(14) index2__ff (index2, index2__d1, rst, clk);
  wire w_index_op__useIndex1 = currentCmd_updateSyncAny | currentCmd_updateSlowMemIn;

  wire [14-1:0] w_index_op__a2 = w_index_op__useIndex1    ? index1
                               : currentCmd_updateFastAny ? index2__d1
                                                          : index2;
  wire [14-1:0] w_index_op__a1;
  delay #(14) w_index_op__ff2 (w_index_op__a2, w_index_op__a1, rst, clk);
  wire [14-1:0] w_index_op;
  delay #(14) w_index_op__ff1 (w_index_op__a1, w_index_op, rst, clk);

  assign w_index = currentCmd_in ? index2 : w_index_op;
endmodule





`define MemAndMulCMD_op_CpleqStimesBT  6'd0 /* BRAM.C = BRAM.C + BRAM.S' *' BRAM.B'^T */
`define MemAndMulCMD_op_UeqCminBtimesS 6'd1 /* BRAM.u = decode(BRAM.C - (BRAM.S' *' BRAM.B'^T)^T) */
`define MemAndMulCMD_op_CeqUminC       6'd2 /* BRAM.C = Encode(BRAM.u) - BRAM.C */
`define MemAndMulCMD_op_CeqU           6'd3 /* BRAM.C = Encode(BRAM.u) */
`define MemAndMulCMD_op_Erase1         6'd4 /* BRAM.S' = 0 */
`define MemAndMulCMD_op_Erase2         6'd5 /* BRAM.u = 0 ; BRAM.seedSE = 0 ; BRAM.k = 0 */
`define MemAndMulCMD_op_Erase3         6'd6 /* BRAM.B' = 0 ; BRAM.C = 0 */

`define MemAndMulCMD_inOp_BpleqStimesInAT 6'd7 /* BRAM.B' = BRAM.B'+ BRAM.S' *' _A^T */
`define MemAndMulCMD_inOp_BpleqStimesInA  6'd8 /* BRAM.B' = BRAM.B' + BRAM.S' *'' _A */
`define MemAndMulCMD_inOp_CpleqStimesInB  6'd9 /* BRAM.C = BRAM.C + BRAM.S' *' _B */
`define MemAndMulCMD_inOp_addCRowFirst    6'd10 /* BRAM.C = BRAM.C + _C */
`define MemAndMulCMD_inOp_selectKey       6'd11 /* BRAM.k = BRAM.B' == 0 && BRAM.C == 0 ? BRAM.k : _s */
`define MemAndMulCMD_inOp_BeqInMinB       6'd12 /* BRAM.B' = _B - BRAM.B' */

`define MemAndMulCMD_in_BRowFirst 6'd13
`define MemAndMulCMD_in_BColFirst 6'd14
`define MemAndMulCMD_in_SRowFirst 6'd15 /* it changes the encoding when storing, to save space */
`define MemAndMulCMD_in_CRowFirst 6'd16
`define MemAndMulCMD_in_SSState   6'd17
`define MemAndMulCMD_in_RNGState  6'd18
`define MemAndMulCMD_in_salt      6'd19
`define MemAndMulCMD_in_seedSE    6'd20
`define MemAndMulCMD_in_pkh       6'd21
`define MemAndMulCMD_in_u         6'd22
`define MemAndMulCMD_in_k         6'd23

`define MemAndMulCMD_out_BRowFirst 6'd24
`define MemAndMulCMD_out_BColFirst 6'd25
`define MemAndMulCMD_out_SRowFirst_DBG 6'd26 /* only 16b of the bus are used, it outputs the internal representation for debug. There is no other way to get any info on the value stored in S, otherwise. */
`define MemAndMulCMD_out_CRowFirst 6'd27
`define MemAndMulCMD_out_SSState   6'd28
`define MemAndMulCMD_out_RNGState  6'd29
`define MemAndMulCMD_out_salt      6'd30
`define MemAndMulCMD_out_seedSE    6'd31
`define MemAndMulCMD_out_pkh       6'd32
`define MemAndMulCMD_out_u         6'd33
`define MemAndMulCMD_out_k         6'd34

`define MemAndMulCMD_SIZE       6
`define MemAndMulCMD_FULLSIZE  35
`define MemAndMulCMD_mask_op       35'h00000007F
`define MemAndMulCMD_mask_inOp     35'h000001F80
`define MemAndMulCMD_mask_opMul1   35'h000000283
`define MemAndMulCMD_mask_opMul    35'h000000383
`define MemAndMulCMD_mask_opNoMul  35'h000001C7C
`define MemAndMulCMD_mask_in       35'h000FFE000
`define MemAndMulCMD_mask_out      35'h7FF000000
`define MemAndMulCMD_mask_conflictIn   (`MemAndMulCMD_mask_in  | `MemAndMulCMD_mask_op | `MemAndMulCMD_mask_inOp)
`define MemAndMulCMD_mask_conflictOut  (`MemAndMulCMD_mask_out | `MemAndMulCMD_mask_op | `MemAndMulCMD_mask_inOp)
`define MemAndMulCMD_mask_zero     35'h0



`ATTR_MOD_GLOBAL
module encode(
  input [4-1:0] in,
  output [16-1:0] out
);
  assign out = {in, 12'b0};
endmodule

`ATTR_MOD_GLOBAL
module encode4(
  input [4*4-1:0] in,
  output [16*4-1:0] out
);
  encode e0(in[0*4+:4], out[0*16+:16]);
  encode e1(in[1*4+:4], out[1*16+:16]);
  encode e2(in[2*4+:4], out[2*16+:16]);
  encode e3(in[3*4+:4], out[3*16+:16]);
endmodule

`ATTR_MOD_GLOBAL
module decode(
  input [16-1:0] in,
  output [4-1:0] out
);
  wire ignore = in[11-1:0];
  assign out = {(in[11+:5] + 5'b1) >> 1};
endmodule

`ATTR_MOD_GLOBAL
module decode8(
  input [16*8-1:0] in,
  output [4*8-1:0] out
);
  decode d0(in[0*16+:16], out[0*4+:4]);
  decode d1(in[1*16+:16], out[1*4+:4]);
  decode d2(in[2*16+:16], out[2*4+:4]);
  decode d3(in[3*16+:16], out[3*4+:4]);
  decode d4(in[4*16+:16], out[4*4+:4]);
  decode d5(in[5*16+:16], out[5*4+:4]);
  decode d6(in[6*16+:16], out[6*4+:4]);
  decode d7(in[7*16+:16], out[7*4+:4]);
endmodule

`define MEMANDMUL__CORE__MAX_NUM_STATES 3

`ATTR_MOD_GLOBAL
module memAndMul__core(
    input [`MemAndMulCMD_FULLSIZE-1:0] currentCmd,
    input currentCmd_in_isFirstCycle,
    input currentCmd_out_isFirstCycle,
    output currentCmd_in_isLastCycle,
    output currentCmd_out_isLastCycle, // the bus_out__d2 can output after this is active as this is to start new commands

    input bus_inOp_isReady,
    input [64-1:0] bus_inOp,
    output bus_inOp_canReceive,
    output bus_inOp_isLast,

    input bus_in_isReady,
    input [64-1:0] bus_in,

    input bus_out_canReceive,
    output [64-1:0] bus_out__d2,

    input rst,
    input clk
  );

  wire isAnyOP = | (currentCmd & ~`MemAndMulCMD_mask_in & ~`MemAndMulCMD_mask_out);
  
  
  // state
  wire [`MEMANDMUL__CORE__MAX_NUM_STATES-1:0] state;
  wor [$clog2(`MEMANDMUL__CORE__MAX_NUM_STATES+1)-1:0] state__numStates;
  wire state__isLast;
  wire state__hasAny;
  wire state__consume;
  counter_bus_state #(.MAX_NUM_STEPS(`MEMANDMUL__CORE__MAX_NUM_STATES)) state__counter (
    .restart(isAnyOP),
    .numStates(state__numStates),
    .isLast(state__isLast),
    .hasAny(state__hasAny),
    .state(state),
    .consume(state__consume),
    .rst(rst),
    .clk(clk)
  );
  wire state__consume__d1;
  delay state__consume__ff (state__consume, state__consume__d1, rst, clk);
  wire state__isFirstCycle = isAnyOP & currentCmd_in_isFirstCycle
                           | state__consume__d1 & state__hasAny;


  // index handler module
  wor [`MemAndMulIndexCMD_SIZE-1:0] indexHandler__currentCmd;
  wor indexHandler__currentCmd_in_isFirstCycle = isAnyOP ? state__isFirstCycle : currentCmd_in_isFirstCycle;
  wor indexHandler__currentCmd_out_isFirstCycle = isAnyOP ? state__isFirstCycle : currentCmd_out_isFirstCycle;
  wire indexHandler__currentCmd_in_isLastCycle;
  wire indexHandler__currentCmd_out_isLastCycle;
  wire [14-1:0] indexHandler__r_index;
  wire [14-1:0] indexHandler__r_index_next;
  wire indexHandler__r_index_hasNext;
  wire [14-1:0] indexHandler__w_index;
  wire [14-1:0] indexHandler__w_index_next;
  wire indexHandler__w_index_hasNext;
  wire indexHandler__r_index__useIndex1;
  wire indexHandler__index1__toggle;
  wire indexHandler__r_enable;
  wire indexHandler__r_enable__d2;
  wire indexHandler__w_enable;
  wor indexHandler__bus_in_isReady = bus_in_isReady;
  wor indexHandler__bus_out_canReceive = bus_out_canReceive;
  memAndMul__indexHandler indexHandler(
    .currentCmd(indexHandler__currentCmd),
    .currentCmd_in_isFirstCycle(indexHandler__currentCmd_in_isFirstCycle),
    .currentCmd_out_isFirstCycle(indexHandler__currentCmd_out_isFirstCycle),
    .currentCmd_in_isLastCycle(indexHandler__currentCmd_in_isLastCycle),
    .currentCmd_out_isLastCycle(indexHandler__currentCmd_out_isLastCycle),

    .bus_inOp_isReady(bus_inOp_isReady),
    .bus_inOp_canReceive(bus_inOp_canReceive),
    .bus_inOp_isLast(bus_inOp_isLast),
    .bus_in_isReady(indexHandler__bus_in_isReady),
    .bus_out_canReceive(indexHandler__bus_out_canReceive),

    .r_index(indexHandler__r_index),
    .r_index_next(indexHandler__r_index_next),
    .r_index_hasNext(indexHandler__r_index_hasNext),
    .w_index(indexHandler__w_index),
    .w_index_next(indexHandler__w_index_next),
    .w_index_hasNext(indexHandler__w_index_hasNext),

    .r_index__useIndex1(indexHandler__r_index__useIndex1),
    .index1__toggle(indexHandler__index1__toggle),
    .r_enable(indexHandler__r_enable),
    .r_enable__d2(indexHandler__r_enable__d2),
    .w_enable(indexHandler__w_enable),

    .rst(rst),
    .clk(clk)
  );
  assign currentCmd_in_isLastCycle = isAnyOP ? state__isLast : indexHandler__currentCmd_in_isLastCycle;
  assign currentCmd_out_isLastCycle = isAnyOP ? state__isLast : indexHandler__currentCmd_out_isLastCycle;
  assign state__consume = isAnyOP & (indexHandler__currentCmd_in_isLastCycle | indexHandler__currentCmd_out_isLastCycle);

  // adder
  wor [64-1:0] adder__op1;
  wor [64-1:0] adder__op2;
  wor adder__neg2;
  wire [64-1:0] adder__ret;
  genvar j;
  generate
    for (j = 0; j < 4; j=j+1) begin
      assign adder__ret[j*16+:16] = adder__op1[j*16+:16] + (adder__neg2 ? -adder__op2[j*16+:16] : adder__op2[j*16+:16]);
    end
  endgenerate
  
  // isZero
  wor isNotZero__isFirst;
  wor isNotZero__set;
  wire isNotZero__d1;
  wire isNotZero = isNotZero__set | isNotZero__d1 & ~ isNotZero__isFirst;
  delay isNotZero__ff(isNotZero, isNotZero__d1, rst, clk);
  wor [64-1:0] isNotZero__onTrue;
  wor [64-1:0] isNotZero__onFalse;
  wire [64-1:0] isNotZero__ret = isNotZero ? isNotZero__onTrue : isNotZero__onFalse;

  // main memory module
  wor mainMemory__w_bus__useAdder;
  wor mainMemory__w_bus__toZero;
  wor mainMemory__w_bus__useIsNotZero;
  wire [64-1:0] mainMemory__w_bus = mainMemory__w_bus__useAdder             ? adder__ret
                                  : mainMemory__w_bus__useIsNotZero         ? isNotZero__ret
                                  : mainMemory__w_bus__toZero               ? 64'b0
                                  : currentCmd & `MemAndMulCMD_mask_in != 0 ? bus_in
                                                                            : bus_inOp; // TODO: whut

  wor [`MainMemCMD_SIZE-1:0] mainMemory__r_bus_cmd;
  wor [`MainMemCMD_SIZE-1:0] mainMemory__w_bus_cmd;

  wire [16*4-1:0] mainMemory__r_bus__d2;
  assign bus_out__d2 = mainMemory__r_bus__d2;

  wor mainMemory__r_dubBus_B_col;
  wor mainMemory__r_dubBus_C_col;
  wor mainMemory__r_dubBus_C_row;
  wor mainMemory__r_dubBus_S_mat;
  wor mainMemory__r_paral_B_mat;
  wor mainMemory__r_halfBus_S_col;
  wor mainMemory__r_quarterBus_U_row;
  wor mainMemory__w_dubBus_B_col;
  wor mainMemory__w_dubBus_C_col;
  wor mainMemory__w_paral_B_mat;
  wor mainMemory__w_halfBus_U_row;

  wire [16*8-1:0] mainMemory__r_dubBus__d2;
  wire [16*4*8-1:0] mainMemory__r_paral__d2;
  wire [4*8-1:0] mainMemory__r_halfBus__d2;
  wire [4*4-1:0] mainMemory__r_quarterBus__d2;
  wire [16*8-1:0] mainMemory__w_dubBus;
  wire [16*4*8-1:0] mainMemory__w_paral;
  wire [4*8-1:0] mainMemory__w_halfBus;
  mainMem mainMemory(
    .r_bus__d2(mainMemory__r_bus__d2),
    .w_bus(mainMemory__w_bus),

    .r_index(indexHandler__r_index),
    .r_index_next(indexHandler__r_index_next),
    .r_index_hasNext(indexHandler__r_index_hasNext),
    .w_index(indexHandler__w_index),
    .w_index_next(indexHandler__w_index_next),
    .w_index_hasNext(indexHandler__w_index_hasNext),

    .r_bus_cmd(mainMemory__r_bus_cmd),
    .w_bus_cmd(mainMemory__w_bus_cmd),

    .r_dubBus_B_col(mainMemory__r_dubBus_B_col),
    .r_dubBus_C_col(mainMemory__r_dubBus_C_col),
    .r_dubBus_C_row(mainMemory__r_dubBus_C_row),
    .r_dubBus_S_mat(mainMemory__r_dubBus_S_mat),
    .r_paral_B_mat(mainMemory__r_paral_B_mat),
    .r_halfBus_S_col(mainMemory__r_halfBus_S_col),
    .r_quarterBus_U_row(mainMemory__r_quarterBus_U_row),

    .r_dubBus__d2(mainMemory__r_dubBus__d2),
    .r_paral__d2(mainMemory__r_paral__d2),
    .r_halfBus__d2(mainMemory__r_halfBus__d2),
    .r_quarterBus__d2(mainMemory__r_quarterBus__d2),

    .w_dubBus_B_col(mainMemory__w_dubBus_B_col),
    .w_dubBus_C_col(mainMemory__w_dubBus_C_col),
    .w_paral_B_mat(mainMemory__w_paral_B_mat),
    .w_halfBus_U_row(mainMemory__w_halfBus_U_row),

    .w_dubBus(mainMemory__w_dubBus),
    .w_paral(mainMemory__w_paral),
    .w_halfBus(mainMemory__w_halfBus),

    .rst(rst),
    .clk(clk)
  );

  //  mul module
  wor [16*4-1:0] m__a__d2;
  wire [128-1:0] m__outVec;
  wor m__isMatrixMul2__d2;
  wire m__isMatrixMul1__d2 = ~m__isMatrixMul2__d2;
  wor m__isNeg__d2;
  wire m__isPos__d2 = ~m__isNeg__d2;
  
  wor m__doOp;
  wire m__doOp__d1;
  delay m__doOp__ff1 (m__doOp, m__doOp__d1, rst, clk);
  wire m__doOp__d2;
  delay m__doOp__ff2 (m__doOp__d1, m__doOp__d2, rst, clk);

  wor m__sCol__doDelay__d2;
  wire [32-1:0] m__sCol__d2d3;
  optionalDelay #(32) r_halfBus__ff (m__sCol__doDelay__d2, mainMemory__r_halfBus__d2, m__sCol__d2d3, rst, clk);

  wire m__setStorage = ~indexHandler__r_index__useIndex1;
  wire m__setStorage__d1;
  delay m__setStorage__ff2 (m__setStorage, m__setStorage__d1, rst, clk);
  wire m__setStorage__d2;
  delay m__setStorage__ff1 (m__setStorage__d1, m__setStorage__d2, rst, clk);
  frodoMul m(
    .a(m__a__d2),
    .accVec(mainMemory__r_dubBus__d2),
    .sCol(m__sCol__d2d3),
    .sMat(mainMemory__r_dubBus__d2),
    .accMat(mainMemory__r_paral__d2),
    .outMat(mainMemory__w_paral),
    .outVec(m__outVec),
    .isMatrixMul1(m__isMatrixMul1__d2),
    .isPos(m__isPos__d2),
    .setStorage(m__setStorage__d2),
    .doOp(m__doOp__d2),
    .rst(rst),
    .clk(clk)
  );
  assign mainMemory__w_dubBus = m__outVec;
  decode8 decode(m__outVec, mainMemory__w_halfBus);

  // encoding and delayed in bus
  wor r_encoded_U__d2d3__doDelay;
  wire [4*4-1:0] r_quarterBus__d2d3;
  optionalDelay #(16) r_quarterBus__ff (r_encoded_U__d2d3__doDelay, mainMemory__r_quarterBus__d2, r_quarterBus__d2d3, rst, clk);
  wire [16*4-1:0] r_encoded_U__d2d3;
  encode4 encode(r_quarterBus__d2d3, r_encoded_U__d2d3);

  wire [64-1:0] bus_inOp__d1;
  delay #(64) bus_inOp__ff1 (bus_inOp, bus_inOp__d1, rst, clk);
  wire [64-1:0] bus_inOp__d2;
  delay #(64) bus_inOp__ff2 (bus_inOp__d1, bus_inOp__d2, rst, clk);

  assign indexHandler__currentCmd = (currentCmd & `MemAndMulCMD_mask_in) != 0 ? `MemAndMulIndexCMD_in : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_B_row] = currentCmd[`MemAndMulCMD_in_BRowFirst] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_B_col] = currentCmd[`MemAndMulCMD_in_BColFirst] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_in_CRowFirst] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_S_row] = currentCmd[`MemAndMulCMD_in_SRowFirst] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_SSState] = currentCmd[`MemAndMulCMD_in_SSState] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_RNGState] = currentCmd[`MemAndMulCMD_in_RNGState] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_salt] = currentCmd[`MemAndMulCMD_in_salt] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_seedSE] = currentCmd[`MemAndMulCMD_in_seedSE] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_pkh] = currentCmd[`MemAndMulCMD_in_pkh] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_k] = currentCmd[`MemAndMulCMD_in_k] & bus_in_isReady;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_U_twoRows] = currentCmd[`MemAndMulCMD_in_u] & bus_in_isReady;

  assign indexHandler__currentCmd = (currentCmd & `MemAndMulCMD_mask_out) != 0 ? `MemAndMulIndexCMD_out : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_B_row] = currentCmd[`MemAndMulCMD_out_BRowFirst] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_B_col] = currentCmd[`MemAndMulCMD_out_BColFirst] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_out_CRowFirst] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_S_row] = currentCmd[`MemAndMulCMD_out_SRowFirst_DBG] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_SSState] = currentCmd[`MemAndMulCMD_out_SSState] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_RNGState] = currentCmd[`MemAndMulCMD_out_RNGState] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_salt] = currentCmd[`MemAndMulCMD_out_salt] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_seedSE] = currentCmd[`MemAndMulCMD_out_seedSE] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_pkh] = currentCmd[`MemAndMulCMD_out_pkh] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_k] = currentCmd[`MemAndMulCMD_out_k] & bus_out_canReceive;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_U_twoRows] = currentCmd[`MemAndMulCMD_out_u] & bus_out_canReceive;

  assign state__numStates                             = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] ? 1 : 0;
  assign indexHandler__currentCmd                     = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] ? `MemAndMulIndexCMD_updateFastMemMem : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_dubBus_C_col                   = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & indexHandler__w_enable;
  assign mainMemory__r_dubBus_C_col                   = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & ~indexHandler__r_index__useIndex1;
  assign mainMemory__r_dubBus_S_mat                   = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & indexHandler__r_index__useIndex1 & ~indexHandler__index1__toggle;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_B_row] = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & indexHandler__r_index__useIndex1 & indexHandler__index1__toggle;
  assign m__doOp                                      = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & indexHandler__r_index__useIndex1 & indexHandler__index1__toggle & indexHandler__r_enable;
  assign m__a__d2                                     = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] ? mainMemory__r_bus__d2 : 64'b0;
  assign m__sCol__doDelay__d2                         = currentCmd[`MemAndMulCMD_op_CpleqStimesBT];

  assign state__numStates                             = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] ? 1 : 0;
  assign indexHandler__currentCmd                     = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] ? `MemAndMulIndexCMD_updateFastMemMem : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_halfBus_U_row                  = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & indexHandler__w_enable;
  assign mainMemory__r_dubBus_C_row                   = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & ~indexHandler__r_index__useIndex1;
  assign mainMemory__r_dubBus_S_mat                   = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & indexHandler__r_index__useIndex1 & ~indexHandler__index1__toggle;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_B_row] = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & indexHandler__r_index__useIndex1 & indexHandler__index1__toggle;
  assign m__doOp                                      = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & indexHandler__r_index__useIndex1 & indexHandler__index1__toggle & indexHandler__r_enable;
  assign m__isNeg__d2                                 = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS];
  assign m__a__d2                                     = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] ? mainMemory__r_bus__d2 : 64'b0;
  assign m__sCol__doDelay__d2                         = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS];

  assign state__numStates           = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] ? 1 : 0;
  assign indexHandler__currentCmd   = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] ? `MemAndMulIndexCMD_updateFastMemIn : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_dubBus_B_col = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] & indexHandler__w_enable;
  assign mainMemory__r_dubBus_B_col = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] & ~indexHandler__r_index__useIndex1;
  assign mainMemory__r_dubBus_S_mat = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] & indexHandler__r_index__useIndex1;
  assign m__doOp                    = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] & indexHandler__r_index__useIndex1 & indexHandler__r_enable;
  assign m__a__d2                   = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] ? bus_inOp__d2 : 64'b0;

  assign state__numStates           = currentCmd[`MemAndMulCMD_inOp_CpleqStimesInB] ? 1 : 0;
  assign indexHandler__currentCmd   = currentCmd[`MemAndMulCMD_inOp_CpleqStimesInB] ? `MemAndMulIndexCMD_updateFastMemIn : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_dubBus_C_col = currentCmd[`MemAndMulCMD_inOp_CpleqStimesInB] & indexHandler__w_enable;
  assign mainMemory__r_dubBus_C_col = currentCmd[`MemAndMulCMD_inOp_CpleqStimesInB] & ~indexHandler__r_index__useIndex1;
  assign mainMemory__r_dubBus_S_mat = currentCmd[`MemAndMulCMD_inOp_CpleqStimesInB] & indexHandler__r_index__useIndex1;
  assign m__doOp                    = currentCmd[`MemAndMulCMD_inOp_CpleqStimesInB] & indexHandler__r_index__useIndex1 & indexHandler__r_enable;
  assign m__a__d2                   = currentCmd[`MemAndMulCMD_inOp_CpleqStimesInB] ? bus_inOp__d2 : 64'b0;

  assign state__numStates            = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] ? 1 : 0;
  assign indexHandler__currentCmd    = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] ? `MemAndMulIndexCMD_updateSlowMemIn : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_paral_B_mat   = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] & indexHandler__w_enable;
  assign mainMemory__r_halfBus_S_col = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] & ~indexHandler__r_index__useIndex1;
  assign mainMemory__r_paral_B_mat   = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] & indexHandler__r_index__useIndex1;
  assign m__doOp                     = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] & indexHandler__r_index__useIndex1;
  assign m__isMatrixMul2__d2         = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA];
  assign m__a__d2                    = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] ? bus_inOp__d2 : 64'b0;

  assign state__numStates                             = currentCmd[`MemAndMulCMD_op_CeqUminC] ? 1 : 0;
  assign indexHandler__currentCmd                     = currentCmd[`MemAndMulCMD_op_CeqUminC] ? `MemAndMulIndexCMD_updateSyncMem : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_op_CeqUminC] & indexHandler__w_enable;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_op_CeqUminC] & indexHandler__index1__toggle;
  assign mainMemory__r_quarterBus_U_row               = currentCmd[`MemAndMulCMD_op_CeqUminC] & ~indexHandler__index1__toggle;
  assign mainMemory__w_bus__useAdder                  = currentCmd[`MemAndMulCMD_op_CeqUminC];
  assign r_encoded_U__d2d3__doDelay                   = currentCmd[`MemAndMulCMD_op_CeqUminC];
  assign adder__op1                                   = currentCmd[`MemAndMulCMD_op_CeqUminC] ? r_encoded_U__d2d3 : 64'b0;
  assign adder__op2                                   = currentCmd[`MemAndMulCMD_op_CeqUminC] ? mainMemory__r_bus__d2 : 64'b0;
  assign adder__neg2                                  = currentCmd[`MemAndMulCMD_op_CeqUminC];

  assign state__numStates                             = currentCmd[`MemAndMulCMD_op_CeqU] ? 1 : 0;
  assign indexHandler__currentCmd                     = currentCmd[`MemAndMulCMD_op_CeqU] ? `MemAndMulIndexCMD_updateSync : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_op_CeqU] & indexHandler__w_enable;
  assign mainMemory__r_quarterBus_U_row               = currentCmd[`MemAndMulCMD_op_CeqU];
  assign mainMemory__w_bus__useAdder                  = currentCmd[`MemAndMulCMD_op_CeqU];
  assign adder__op1                                   = currentCmd[`MemAndMulCMD_op_CeqU] ? r_encoded_U__d2d3 : 64'b0;

  assign state__numStates                             = currentCmd[`MemAndMulCMD_inOp_BeqInMinB] ? 1 : 0;
  assign indexHandler__currentCmd                     = currentCmd[`MemAndMulCMD_inOp_BeqInMinB] ? `MemAndMulIndexCMD_updateSyncIn : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_B_row] = currentCmd[`MemAndMulCMD_inOp_BeqInMinB] & indexHandler__w_enable;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_B_row] = currentCmd[`MemAndMulCMD_inOp_BeqInMinB];
  assign mainMemory__w_bus__useAdder                  = currentCmd[`MemAndMulCMD_inOp_BeqInMinB];
  assign adder__op1                                   = currentCmd[`MemAndMulCMD_inOp_BeqInMinB] ? bus_inOp__d2 : 64'b0;
  assign adder__op2                                   = currentCmd[`MemAndMulCMD_inOp_BeqInMinB] ? mainMemory__r_bus__d2 : 64'b0;
  assign adder__neg2                                  = currentCmd[`MemAndMulCMD_inOp_BeqInMinB];

  assign state__numStates                             = currentCmd[`MemAndMulCMD_inOp_addCRowFirst] ? 1 : 0;
  assign indexHandler__currentCmd                     = currentCmd[`MemAndMulCMD_inOp_addCRowFirst] ? `MemAndMulIndexCMD_updateSyncIn : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & indexHandler__w_enable;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_inOp_addCRowFirst];
  assign mainMemory__w_bus__useAdder                  = currentCmd[`MemAndMulCMD_inOp_addCRowFirst];
  assign adder__op1                                   = currentCmd[`MemAndMulCMD_inOp_addCRowFirst] ? bus_inOp__d2 : 64'b0;
  assign adder__op2                                   = currentCmd[`MemAndMulCMD_inOp_addCRowFirst] ? mainMemory__r_bus__d2 : 64'b0;

  assign state__numStates                             = currentCmd[`MemAndMulCMD_inOp_selectKey] ? 3 : 0;
  assign indexHandler__currentCmd          = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[0] ? `MemAndMulIndexCMD_out : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign indexHandler__bus_out_canReceive  = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[0];
  assign mainMemory__r_dubBus_B_col        = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[0];
  assign isNotZero__isFirst                = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[0] & state__isFirstCycle;
  assign isNotZero__set                    = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[0] & indexHandler__r_enable__d2 & mainMemory__r_dubBus__d2 != 0;
  assign indexHandler__currentCmd              = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[1] ? `MemAndMulIndexCMD_out : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign indexHandler__bus_out_canReceive      = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[1];
  assign mainMemory__r_dubBus_C_col            = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[1];
  assign isNotZero__set                        = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[1] & indexHandler__r_enable__d2 & mainMemory__r_dubBus__d2 != 0;
  assign indexHandler__currentCmd                 = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[2] ? `MemAndMulIndexCMD_updateSyncIn : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_k] = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[2] & indexHandler__w_enable;
  assign mainMemory__r_bus_cmd[`MainMemCMD_bus_k] = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[2];
  assign mainMemory__w_bus__useIsNotZero          = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[2];
  assign isNotZero__onTrue                        = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[2] ? bus_inOp__d2 : 64'b0;
  assign isNotZero__onFalse                       = currentCmd[`MemAndMulCMD_inOp_selectKey] & state[2] ? mainMemory__r_bus__d2 : 64'b0;

  assign state__numStates                             = currentCmd[`MemAndMulCMD_op_Erase1] ? 1 : 0;
  assign indexHandler__currentCmd                     = currentCmd[`MemAndMulCMD_op_Erase1] ? `MemAndMulIndexCMD_in : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign indexHandler__bus_in_isReady                 = currentCmd[`MemAndMulCMD_op_Erase1];
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_S_row] = currentCmd[`MemAndMulCMD_op_Erase1] & indexHandler__w_enable;
  assign mainMemory__w_bus__toZero                    = currentCmd[`MemAndMulCMD_op_Erase1];

  assign state__numStates                                 = currentCmd[`MemAndMulCMD_op_Erase2] ? 3 : 0;
  assign mainMemory__w_bus__toZero                        = currentCmd[`MemAndMulCMD_op_Erase2];
  assign indexHandler__currentCmd                         = currentCmd[`MemAndMulCMD_op_Erase2] ? `MemAndMulIndexCMD_in : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign indexHandler__bus_in_isReady                     = currentCmd[`MemAndMulCMD_op_Erase2];
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_U_twoRows] = currentCmd[`MemAndMulCMD_op_Erase2] & state[0] & indexHandler__w_enable;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_seedSE]    = currentCmd[`MemAndMulCMD_op_Erase2] & state[1] & indexHandler__w_enable;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_k]         = currentCmd[`MemAndMulCMD_op_Erase2] & state[2] & indexHandler__w_enable;

  assign state__numStates                             = currentCmd[`MemAndMulCMD_op_Erase3] ? 2 : 0;
  assign mainMemory__w_bus__toZero                    = currentCmd[`MemAndMulCMD_op_Erase3];
  assign indexHandler__currentCmd                     = currentCmd[`MemAndMulCMD_op_Erase3] ? `MemAndMulIndexCMD_in : {`MemAndMulIndexCMD_SIZE{1'b0}};
  assign indexHandler__bus_in_isReady                 = currentCmd[`MemAndMulCMD_op_Erase3];
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_B_row] = currentCmd[`MemAndMulCMD_op_Erase3] & state[0] & indexHandler__w_enable;
  assign mainMemory__w_bus_cmd[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_op_Erase3] & state[1] & indexHandler__w_enable;

endmodule

`ATTR_MOD_GLOBAL
module memAndMul__outAdapter(
    input currentCMD__isOut,
    input currentCmd_out_isLastCycle,

    output bus_in_canReceive,
    input [64-1:0] bus_in__d2,

    output bus_out_isReady,
    output bus_out_isLast,
    output [64-1:0] bus_out,
    input bus_out_canReceive,

    input rst,
    input clk
  );

  wire bus_in_isReady = bus_out_canReceive & currentCMD__isOut;
  assign bus_in_canReceive = bus_in_isReady;
  wire bus_in_isReady__d1;
  delay bus_in_isReady__ff1 (bus_in_isReady, bus_in_isReady__d1, rst, clk);
  wire bus_in_isReady__d2;
  delay bus_in_isReady__ff2 (bus_in_isReady__d1, bus_in_isReady__d2, rst, clk);
  wire bus_in_isLast = currentCmd_out_isLastCycle;
  wire bus_in_isLast__d1;
  delay bus_in_isLast__ff1 (bus_in_isLast, bus_in_isLast__d1, rst, clk);
  wire bus_in_isLast__d2;
  delay bus_in_isLast__ff2 (bus_in_isLast__d1, bus_in_isLast__d2, rst, clk);

  wire [64*2-1:0] buffer;
  wire [64*2-1:0] buffer__a1;
  delay #(64*2) buffer__ff (buffer__a1, buffer, rst, clk);
  wire [2-1:0] buffer_isReady;
  wire [2-1:0] buffer_isReady__a1;
  delay #(2) buffer_isReady__ff (buffer_isReady__a1, buffer_isReady, rst, clk);
  wire [2-1:0] buffer_isLast;
  wire [2-1:0] buffer_isLast__a1;
  delay #(2) buffer_isLast__ff (buffer_isLast__a1, buffer_isLast, rst, clk);

  wire [3-1:0] merged_isReady;
  wire [64*3-1:0] merged;
  wire [3-1:0] merged_isLast;
  assign merged_isReady[0] = buffer_isReady[0] | bus_in_isReady__d2;
  assign merged_isReady[1] = buffer_isReady[1] | (buffer_isReady[0] & bus_in_isReady__d2);
  assign merged_isReady[2] = buffer_isReady[0] & buffer_isReady[1] & bus_in_isReady__d2;
  assign merged_isLast[0] = buffer_isReady[0]  ? buffer_isLast[0]
                          : bus_in_isReady__d2 ? bus_in_isLast__d2
                                               : 1'b0;
  assign merged_isLast[1] = buffer_isReady[1]                      ? buffer_isLast[1]
                          : buffer_isReady[0] & bus_in_isReady__d2 ? bus_in_isLast__d2
                                                                   : 1'b0;
  assign merged_isLast[2] = buffer_isReady[0] & buffer_isReady[1] & bus_in_isReady__d2 ? bus_in_isLast__d2
                                                                                       : 1'b0;
  assign merged[0*64+:64] = buffer_isReady[0]   ? buffer[0*64+:64]
                          : bus_in_isReady__d2  ? bus_in__d2
                                                : 64'b0;
  assign merged[1*64+:64] = buffer_isReady[1]                      ? buffer[1*64+:64]
                          : buffer_isReady[0] & bus_in_isReady__d2 ? bus_in__d2
                                                                   : 64'b0;
  assign merged[2*64+:64] = buffer_isReady[0] & buffer_isReady[1] & bus_in_isReady__d2 ? bus_in__d2
                                                                                       : 1'b0;

  assign bus_out_isReady = bus_out_canReceive ? merged_isReady[0] : 1'b0;
  assign bus_out_isLast = bus_out_canReceive ? merged_isLast[0] : 1'b0;
  assign bus_out = bus_out_canReceive ? merged[0+:64] : 64'b0;

  assign buffer_isReady__a1 = bus_out_canReceive ? merged_isReady[1+:2] : merged_isReady[0+:2];
  assign buffer_isLast__a1 = bus_out_canReceive ? merged_isLast[1+:2] : merged_isLast[0+:2];
  assign buffer__a1 = bus_out_canReceive ? merged[1*64+:64*2] : merged[0*64+:64*2];
endmodule

`ATTR_MOD_GLOBAL
module memAndMul(
    input [`MemAndMulCMD_SIZE-1:0] cmd,
    input cmd_isReady,
    output cmd_canReceive,

    input in_isReady,
    input [64-1:0] in,
    output in_canReceive,
    output in_isLast,

    output out_isReady,
    output out_isLast,
    output [64-1:0] out,
    input out_canReceive,

    input rst,
    input clk
  );

  wire [`MemAndMulCMD_SIZE-1:0] cmdB__raw;
  wire cmdB_hasAny;
  wire cmdB_consume;
  cmd_buffer1 #(.CmdSize(`MemAndMulCMD_SIZE)) cmdBuf (
    .i(cmd),
    .i_isReady(cmd_isReady),
    .i_canReceive(cmd_canReceive),
    .o(cmdB__raw),
    .o_hasAny(cmdB_hasAny),
    .o_consume(cmdB_consume),
    .rst(rst),
    .clk(clk)
  );
  wire [`MemAndMulCMD_FULLSIZE-1:0] cmdB = 1 << cmdB__raw;

  wire currentCmd_in_isLastCycle;
  wire currentCmd_out_isLastCycle;
  wire [`MemAndMulCMD_FULLSIZE-1:0] currentCmd;

  wire [`MemAndMulCMD_FULLSIZE-1:0] nextCmd = currentCmd
           & ~(currentCmd_in_isLastCycle ? `MemAndMulCMD_mask_conflictIn : `MemAndMulCMD_mask_zero)
           & ~(currentCmd_out_isLastCycle ? `MemAndMulCMD_mask_conflictOut : `MemAndMulCMD_mask_zero);
  wire [`MemAndMulCMD_FULLSIZE-1:0] prevCmd;
  delay #(`MemAndMulCMD_FULLSIZE) cmd__ff (nextCmd, prevCmd, rst, clk);
  wire cmdB_conflictIn = | (cmdB & `MemAndMulCMD_mask_conflictIn);
  wire cmdB_conflictOut = | (cmdB & `MemAndMulCMD_mask_conflictOut);
  wire prevCmd_conflictIn = | (prevCmd & `MemAndMulCMD_mask_conflictIn);
  wire prevCmd_conflictOut = | (prevCmd & `MemAndMulCMD_mask_conflictOut);
  wire cmdB_wait = (cmdB_conflictIn & prevCmd_conflictIn)
                 | (cmdB_conflictOut & prevCmd_conflictOut);
  assign cmdB_consume = cmdB_hasAny & ~cmdB_wait;
  assign currentCmd = prevCmd
                    | (cmdB_consume ? cmdB : {`MemAndMulCMD_FULLSIZE{1'b0}});

  wire currentCmd_in_isFirstCycle = | (currentCmd & ~prevCmd & `MemAndMulCMD_mask_conflictIn);
  wire currentCmd_out_isFirstCycle = | (currentCmd & ~prevCmd & `MemAndMulCMD_mask_conflictOut);

  wire core__bus_inOp_isReady;
  wire [64-1:0] core__bus_inOp;
  wire core__bus_inOp_canReceive;
  wire core__bus_inOp_isLast;
  wire core__bus_in_isReady;
  wire [64-1:0] core__bus_in;
  wire core__bus_out_canReceive;
  wire [64-1:0] core__bus_out__d2;
  memAndMul__core core(
    .currentCmd(currentCmd),
    .currentCmd_in_isFirstCycle(currentCmd_in_isFirstCycle),
    .currentCmd_out_isFirstCycle(currentCmd_out_isFirstCycle),
    .currentCmd_in_isLastCycle(currentCmd_in_isLastCycle),
    .currentCmd_out_isLastCycle(currentCmd_out_isLastCycle),
    .bus_inOp_isReady(core__bus_inOp_isReady),
    .bus_inOp(core__bus_inOp),
    .bus_inOp_canReceive(core__bus_inOp_canReceive),
    .bus_inOp_isLast(core__bus_inOp_isLast),
    .bus_in_isReady(core__bus_in_isReady),
    .bus_in(core__bus_in),
    .bus_out_canReceive(core__bus_out_canReceive),
    .bus_out__d2(core__bus_out__d2),
    .rst(rst),
    .clk(clk)
  );

  //wire currentCMD__isOp = | (currentCmd & `MemAndMulCMD_mask_op);
  wire currentCMD__isInOp = | (currentCmd & `MemAndMulCMD_mask_inOp);
  wire currentCMD__isIn = | (currentCmd & `MemAndMulCMD_mask_in);
  wire currentCMD__isOut = | (currentCmd & `MemAndMulCMD_mask_out);
  
  memAndMul__outAdapter o(
    .currentCMD__isOut(currentCMD__isOut),
    .currentCmd_out_isLastCycle(currentCmd_out_isLastCycle),
    .bus_in_canReceive(core__bus_out_canReceive),
    .bus_in__d2(core__bus_out__d2),

    .bus_out_isReady(out_isReady),
    .bus_out_isLast(out_isLast),
    .bus_out(out),
    .bus_out_canReceive(out_canReceive),

    .rst(rst),
    .clk(clk)
  );

  // merge/split the 'in' two ways
  assign in_canReceive = currentCMD__isIn
                       | (currentCMD__isInOp & core__bus_inOp_canReceive);
  assign in_isLast = (currentCMD__isIn & currentCmd_in_isLastCycle)
                   | (currentCMD__isInOp & core__bus_inOp_isLast);
  assign core__bus_inOp_isReady = currentCMD__isInOp & in_isReady;
  assign core__bus_inOp = in;
  assign core__bus_in_isReady = currentCMD__isIn & in_isReady;
  assign core__bus_in = in;
endmodule





