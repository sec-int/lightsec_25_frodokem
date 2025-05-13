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

// TODO: separate the output of 1344 times seedA by allowing read_seedA command in parallel


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


`define MemAndMulCMD_op_CpleqStimesBT 5'd0 /* BRAM.C = BRAM.C + BRAM.S' *' BRAM.B'^T */
`define MemAndMulCMD_op_UeqCminBtimesS 5'd1 /* BRAM.u = decode((BRAM.C^T - BRAM.S' *' BRAM.B'^T)^T) */
`define MemAndMulCMD_op_CeqUminC 5'd2 /* BRAM.C = Encode(BRAM.u) - BRAM.C */
`define MemAndMulCMD_op_CeqU 5'd3 /* BRAM.C = Encode(BRAM.u) */

`define MemAndMulCMD_inOp_BpleqStimesInAT 5'd4 /* BRAM.B' = BRAM.B'+ BRAM.S' *' _A^T */
`define MemAndMulCMD_inOp_BpleqStimesInA 5'd5 /* BRAM.B' = BRAM.B' + BRAM.S' *'' _A */
`define MemAndMulCMD_inOp_CpleqStimesInB 5'd6 /* BRAM.C = BRAM.C + BRAM.S' *' _B */
`define MemAndMulCMD_inOp_addCRowFirst 5'd7 /* BRAM.C = BRAM.C + _C */

`define MemAndMulCMD_in_BRowFirst 5'd8
`define MemAndMulCMD_in_BColFirst 5'd9
`define MemAndMulCMD_in_SRowFirst 5'd10 /* only 16b of the bus are used */
`define MemAndMulCMD_in_CRowFirst 5'd11
`define MemAndMulCMD_in_SSState 5'd12
`define MemAndMulCMD_in_RNGState 5'd13
`define MemAndMulCMD_in_salt 5'd14
`define MemAndMulCMD_in_seedSE 5'd15
`define MemAndMulCMD_in_pkh 5'd16
`define MemAndMulCMD_in_u 5'd17
`define MemAndMulCMD_in_k 5'd18

`define MemAndMulCMD_out_BRowFirst 5'd19
`define MemAndMulCMD_out_BColFirst 5'd20
`define MemAndMulCMD_out_CRowFirst 5'd21
`define MemAndMulCMD_out_SSState 5'd22
`define MemAndMulCMD_out_RNGState 5'd23
`define MemAndMulCMD_out_salt 5'd24
`define MemAndMulCMD_out_seedSE 5'd25
`define MemAndMulCMD_out_pkh 5'd26
`define MemAndMulCMD_out_u 5'd27
`define MemAndMulCMD_out_k 5'd28

`define MemAndMulCMD_FULLSIZE  29
`define MemAndMulCMD_SIZE       5
`define MemAndMulCMD_mask_op       29'h0000000F
`define MemAndMulCMD_mask_inOp     29'h000000F0
`define MemAndMulCMD_mask_opMul1   29'h00000053
`define MemAndMulCMD_mask_opMul    29'h00000073
`define MemAndMulCMD_mask_opNoMul  29'h0000008C
`define MemAndMulCMD_mask_in       29'h0007FF00
`define MemAndMulCMD_mask_out      29'h1FF80000
`define MemAndMulCMD_mask_conflictIn   (`MemAndMulCMD_mask_in  | `MemAndMulCMD_mask_op | `MemAndMulCMD_mask_inOp)
`define MemAndMulCMD_mask_conflictOut  (`MemAndMulCMD_mask_out | `MemAndMulCMD_mask_op | `MemAndMulCMD_mask_inOp)
`define MemAndMulCMD_mask_zero     29'h0

`ATTR_MOD_GLOBAL
module memAndMul__indexHandler(
    input [`MemAndMulCMD_FULLSIZE-1:0] currentCmd,
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

    output [3-1:0] r_which_index, // [0: index1 v1, 1: index1 v2, 2: index2]
    output w_enable,

    input rst,
    input clk
  );

  wire currentCmd_isIn = | (currentCmd & `MemAndMulCMD_mask_in);
  wire currentCmd_isOut = | (currentCmd & `MemAndMulCMD_mask_out);
  wire currentCmd_isInOp = | (currentCmd & `MemAndMulCMD_mask_inOp);
  wire currentCmd_isOpNoMul = | (currentCmd & `MemAndMulCMD_mask_opNoMul);
  wire currentCmd_isOpMul = | (currentCmd & `MemAndMulCMD_mask_opMul);
  wire currentCmd_isOpMul1 = | (currentCmd & `MemAndMulCMD_mask_opMul1);

  wire currentCmd_in_isFirstCycle__d1;
  delay currentCmd_in_isFirstCycle__ff (currentCmd_in_isFirstCycle, currentCmd_in_isFirstCycle__d1, rst, clk);

  // index1 is read or the only one or fast
  // index2 is write or             or slow
  wire index1_isLast__d2;
  wire index1_reset = (currentCmd_isOut & currentCmd_out_isFirstCycle)
                    | (currentCmd_isOpNoMul & currentCmd_in_isFirstCycle)
                    | (currentCmd_isOpMul & (currentCmd_in_isFirstCycle__d1 | index1_isLast__d2));
  wire index1__delay_which__d1;
  wire index1__delay_which = index1_reset ? 1'b0 : ~index1__delay_which__d1;
  delay index1__delay_which__ff(index1__delay_which, index1__delay_which__d1, rst, clk);

  wire index1_has_next;
  wire index1_has_next__d1;
  wire index1_has_val = index1_has_next__d1 | index1_reset;
  wire index1_has_val__d1;
  wire index1_has_val__d2;
  delay index1_has_val__ff1 (index1_has_val, index1_has_val__d1, rst, clk);
  delay index1_has_val__ff2 (index1_has_val__d1, index1_has_val__d2, rst, clk);
  wire index1_isLast__d1 = index1_has_val__d1 & ~index1_has_val;
  assign index1_isLast__d2 = index1_has_val__d2 & ~index1_has_val__d1;
  wire index1_update = currentCmd_isOut & bus_out_canReceive
                     | (currentCmd[`MemAndMulCMD_op_CeqUminC] & (index1__delay_which == 1'b1))
                     | currentCmd[`MemAndMulCMD_op_CeqU]
                     | (currentCmd_isInOp & bus_inOp_isReady)
                     | (currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & (index1__delay_which == 1'b1))
                     | (currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & (index1__delay_which == 1'b1));
  wire [14-1:0] index1_next_input = r_index_next;
  wire index2_has_next;
  wire index2_has_next__d1;
  wire index2_reset = (currentCmd_isIn & currentCmd_in_isFirstCycle)
                    | (currentCmd_isOpNoMul ? 1'b1 : 1'b0)
                    | (currentCmd_isOpMul & currentCmd_in_isFirstCycle);
  wire index2_update = currentCmd_isIn & bus_in_isReady
                     | (currentCmd[`MemAndMulCMD_op_CeqUminC] & (index1__delay_which == 1'b1))
                     | currentCmd[`MemAndMulCMD_op_CeqU]
                     | (currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & bus_inOp_isReady)
                     | (currentCmd_isOpMul & index1_isLast__d1);
  wire [14-1:0] index2_next_input = currentCmd_isIn ? w_index_next : r_index_next;

  wire r_index__is1 = currentCmd_isOut | currentCmd_isOpNoMul | (currentCmd_isOpMul & index1_has_val);
  wire w_index_op__is1 = currentCmd_isOpNoMul | currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA];
  wire w_index_op__is2_isDelayed = currentCmd_isOpMul1;

  wire currentCmd_op_isLastCycle__a2 = (currentCmd[`MemAndMulCMD_op_CeqUminC] & (index1__delay_which == 1'b1) & ~index1_has_next)
                                     | (currentCmd[`MemAndMulCMD_op_CeqU] & ~index1_has_next)
                                     | (currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & bus_inOp_isReady & ~index1_has_next)
                                     | (currentCmd_isOpMul & ~index1_has_next & ~index2_has_next);
  assign bus_inOp_canReceive = (currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & bus_inOp_isReady & index1_has_next)
                             | (currentCmd_isOpMul & index1_has_val);
  assign bus_inOp_isLast = (currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] | currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA])
                         ? index1_has_val & ~index1_has_next
                         : currentCmd_isInOp & currentCmd_op_isLastCycle__a2;
  assign r_which_index = {~r_index__is1, r_index__is1 & index1__delay_which, r_index__is1 & ~index1__delay_which};
  wire w_enable_op__a2 = (currentCmd_isOpMul1 & index1_isLast__d1)
                       | (currentCmd[`MemAndMulCMD_op_CeqU] & index1_has_val)
                       | (currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & bus_inOp_isReady)
                       | (currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] & bus_inOp_isReady) // TODO: why not *AT
                       | (currentCmd[`MemAndMulCMD_op_CeqUminC] & (index1__delay_which == 1'b1));

  wire [14-1:0] index1_next__d1;
  wire [14-1:0] index1 = index1_reset ? 14'b0 : index1_next__d1;
  wire [14-1:0] index1_next = index1_update ? index1_next_input : index1;
  delay #(14) index_next__ff (index1_next, index1_next__d1, rst, clk);
  assign index1_has_next = index1_reset ? 1'b1 : index1_update ? r_index_hasNext : index1_has_next__d1;
  delay index1_has_next__ff (index1_has_next, index1_has_next__d1, rst, clk);
  wire [14-1:0] index2_next__d1;
  wire [14-1:0] index2 = index2_reset ? 14'b0 : index2_next__d1;
  wire [14-1:0] index2_next = index2_update ? index2_next_input : index2;
  delay #(14) index2_next__ff (index2_next, index2_next__d1, rst, clk);
  assign index2_has_next = index2_reset ? 1'b1 : index2_update ? (currentCmd_isIn ? w_index_hasNext : r_index_hasNext) : index2_has_next__d1;
  delay index2_has_next__ff(index2_has_next, index2_has_next__d1, rst, clk);

  wire [14-1:0] index2__delayed;
  ff_en_next #(14) index2__ff (index2_update, index2, index2__delayed, rst, clk);

  assign r_index = r_index__is1 ? index1 : index2;
  wire [14-1:0] w_index_op__a2 = w_index_op__is1 ? index1 : index2;
  wire [14-1:0] w_index_op__a1;
  delay #(14) w_index_op__ff2 (w_index_op__a2, w_index_op__a1, rst, clk);
  wire [14-1:0] w_index_op;
  delay #(14) w_index_op__ff1 (w_index_op__a1, w_index_op, rst, clk);
  assign w_index = currentCmd_isIn ? index2 : w_index_op;

  wire currentCmd_op_isLastCycle__a1;
  delay currentCmd_op_isLastCycle__ff2 (currentCmd_op_isLastCycle__a2, currentCmd_op_isLastCycle__a1, rst, clk);
  wire currentCmd_op_isLastCycle;
  delay currentCmd_op_isLastCycle__ff1 (currentCmd_op_isLastCycle__a1, currentCmd_op_isLastCycle, rst, clk);
  assign currentCmd_in_isLastCycle = currentCmd_isIn ? bus_in_isReady & ~w_index_hasNext : currentCmd_op_isLastCycle;
  assign currentCmd_out_isLastCycle = currentCmd_isOut ? bus_out_canReceive & ~r_index_hasNext : currentCmd_op_isLastCycle;

  wire w_enable_op__a1;
  delay w_enable_op__ff2 (w_enable_op__a2, w_enable_op__a1, rst, clk);
  wire w_enable_op;
  delay w_enable_op__ff1 (w_enable_op__a1, w_enable_op, rst, clk);
  assign w_enable = currentCmd_isIn & bus_in_isReady
                  | w_enable_op;
endmodule

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

  wire [14-1:0] r_index;
  wire [14-1:0] r_index_next;
  wire r_index_hasNext;
  wire [14-1:0] w_index;
  wire [14-1:0] w_index_next;
  wire w_index_hasNext;
  wire [3-1:0] r_which_index;
  wire w_enable;
  memAndMul__indexHandler indexHandler(
    .currentCmd(currentCmd),
    .currentCmd_in_isFirstCycle(currentCmd_in_isFirstCycle),
    .currentCmd_out_isFirstCycle(currentCmd_out_isFirstCycle),
    .currentCmd_in_isLastCycle(currentCmd_in_isLastCycle),
    .currentCmd_out_isLastCycle(currentCmd_out_isLastCycle),

    .bus_inOp_isReady(bus_inOp_isReady),
    .bus_inOp_canReceive(bus_inOp_canReceive),
    .bus_inOp_isLast(bus_inOp_isLast),
    .bus_in_isReady(bus_in_isReady),
    .bus_out_canReceive(bus_out_canReceive),

    .r_index(r_index),
    .r_index_next(r_index_next),
    .r_index_hasNext(r_index_hasNext),
    .w_index(w_index),
    .w_index_next(w_index_next),
    .w_index_hasNext(w_index_hasNext),

    .r_which_index(r_which_index),
    .w_enable(w_enable),

    .rst(rst),
    .clk(clk)
  );

  wire currentCmd_isOpMul1 = | (currentCmd & `MemAndMulCMD_mask_opMul1);

  wire r_dubBus_B_col = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] & r_which_index[2];
  wire r_dubBus_C_col = (currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & r_which_index[2])
                      | (currentCmd[`MemAndMulCMD_inOp_CpleqStimesInB] & r_which_index[2]);
  wire r_dubBus_C_row = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & r_which_index[2];
  wire r_dubBus_S_mat = currentCmd_isOpMul1 & r_which_index[0];
  wire r_paral_B_mat = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] & r_which_index[0];
  wire r_halfBus_S_col = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] & r_which_index[2];
  wire r_quarterBus_U_row = (currentCmd[`MemAndMulCMD_op_CeqUminC] & r_which_index[0])
                          | (currentCmd[`MemAndMulCMD_op_CeqU] & r_which_index[0]);

  wire w_dubBus_B_col = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] & w_enable;
  wire w_dubBus_C_col = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & w_enable;
  wire w_paral_B_mat = currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA] & w_enable;
  wire w_halfBus_U_row = currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & w_enable;

  wire intOp_readBRow = (currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & r_which_index[1])
                      | (currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & r_which_index[1]);
  wire intOp_readCRow = (currentCmd[`MemAndMulCMD_op_CeqUminC] & r_which_index[1])
                      | (currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & r_which_index[0]);
  wire intOp_writeCRow = (currentCmd[`MemAndMulCMD_op_CeqUminC] & w_enable)
                       | (currentCmd[`MemAndMulCMD_op_CeqU] & w_enable)
                       | (currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & w_enable);
  wire m_doOp = (currentCmd[`MemAndMulCMD_op_CpleqStimesBT] & r_which_index[1])
              | (currentCmd[`MemAndMulCMD_op_UeqCminBtimesS] & r_which_index[1])
              | (currentCmd[`MemAndMulCMD_inOp_CpleqStimesInB] & r_which_index[0])
              | (currentCmd[`MemAndMulCMD_inOp_BpleqStimesInAT] & r_which_index[0]); // TODO: why not *A
  wire m_setStorage__a2 = r_which_index[2];
  wire m_setStorage__a1;
  delay m_setStorage__ff2 (m_setStorage__a2, m_setStorage__a1, rst, clk);
  wire m_setStorage;
  delay m_setStorage__ff1 (m_setStorage__a1, m_setStorage, rst, clk);


  wire [16*8-1:0] r_dubBus__d2;
  wire [16*4*8-1:0] r_paral__d2;
  wire [4*8-1:0] r_halfBus__d2;
  wire [4*4-1:0] r_quarterBus__d2;
  wire [16*8-1:0] w_dubBus;
  wire [16*4*8-1:0] w_paral;
  wire [4*8-1:0] w_halfBus;


  wire [`MainMemCMD_SIZE-1:0] r_bus_cmd__raw;
  assign r_bus_cmd__raw[`MainMemCMD_bus_B_row] = currentCmd[`MemAndMulCMD_out_BRowFirst];
  assign r_bus_cmd__raw[`MainMemCMD_bus_B_col] = currentCmd[`MemAndMulCMD_out_BColFirst];
  assign r_bus_cmd__raw[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_out_CRowFirst];
  assign r_bus_cmd__raw[`MainMemCMD_bus_S_row] = 1'b0;
  assign r_bus_cmd__raw[`MainMemCMD_bus_SSState] = currentCmd[`MemAndMulCMD_out_SSState];
  assign r_bus_cmd__raw[`MainMemCMD_bus_RNGState] = currentCmd[`MemAndMulCMD_out_RNGState];
  assign r_bus_cmd__raw[`MainMemCMD_bus_salt] = currentCmd[`MemAndMulCMD_out_salt];
  assign r_bus_cmd__raw[`MainMemCMD_bus_seedSE] = currentCmd[`MemAndMulCMD_out_seedSE];
  assign r_bus_cmd__raw[`MainMemCMD_bus_pkh] = currentCmd[`MemAndMulCMD_out_pkh];
  assign r_bus_cmd__raw[`MainMemCMD_bus_k] = currentCmd[`MemAndMulCMD_out_k];
  assign r_bus_cmd__raw[`MainMemCMD_bus_U_twoRows] = currentCmd[`MemAndMulCMD_out_u];

  wire [`MainMemCMD_SIZE-1:0] w_bus_cmd__raw;
  assign w_bus_cmd__raw[`MainMemCMD_bus_B_row] = currentCmd[`MemAndMulCMD_in_BRowFirst];
  assign w_bus_cmd__raw[`MainMemCMD_bus_B_col] = currentCmd[`MemAndMulCMD_in_BColFirst];
  assign w_bus_cmd__raw[`MainMemCMD_bus_C_row] = currentCmd[`MemAndMulCMD_in_CRowFirst];
  assign w_bus_cmd__raw[`MainMemCMD_bus_S_row] = currentCmd[`MemAndMulCMD_in_SRowFirst];
  assign w_bus_cmd__raw[`MainMemCMD_bus_SSState] = currentCmd[`MemAndMulCMD_in_SSState];
  assign w_bus_cmd__raw[`MainMemCMD_bus_RNGState] = currentCmd[`MemAndMulCMD_in_RNGState];
  assign w_bus_cmd__raw[`MainMemCMD_bus_salt] = currentCmd[`MemAndMulCMD_in_salt];
  assign w_bus_cmd__raw[`MainMemCMD_bus_seedSE] = currentCmd[`MemAndMulCMD_in_seedSE];
  assign w_bus_cmd__raw[`MainMemCMD_bus_pkh] = currentCmd[`MemAndMulCMD_in_pkh];
  assign w_bus_cmd__raw[`MainMemCMD_bus_k] = currentCmd[`MemAndMulCMD_in_k];
  assign w_bus_cmd__raw[`MainMemCMD_bus_U_twoRows] = currentCmd[`MemAndMulCMD_in_u];


  wor [`MainMemCMD_SIZE-1:0] w_bus_cmd = w_bus_cmd__raw & {`MainMemCMD_SIZE{bus_in_isReady}};
  wor [`MainMemCMD_SIZE-1:0] r_bus_cmd = r_bus_cmd__raw & {`MainMemCMD_SIZE{bus_out_canReceive}};
  assign r_bus_cmd[`MainMemCMD_bus_B_row] = intOp_readBRow;
  assign r_bus_cmd[`MainMemCMD_bus_C_row] = intOp_readCRow;
  assign w_bus_cmd[`MainMemCMD_bus_C_row] = intOp_writeCRow;

  wire [64-1:0] w_bus__fromOp;
  wire w_bus__fromOp_enable = w_bus_cmd[`MemAndMulCMD_op_CeqUminC]
                            | w_bus_cmd[`MemAndMulCMD_op_CeqU]
                            | w_bus_cmd[`MemAndMulCMD_inOp_addCRowFirst];
  wire [64-1:0] w_bus = w_bus__fromOp_enable ? w_bus__fromOp : bus_in;
  wire [16*4-1:0] r_bus__d2;
  assign bus_out__d2 = r_bus__d2;

  mainMem mainMemory(
    .r_bus__d2(r_bus__d2),
    .w_bus(w_bus),

    .r_index(r_index),
    .r_index_next(r_index_next),
    .r_index_hasNext(r_index_hasNext),
    .w_index(w_index),
    .w_index_next(w_index_next),
    .w_index_hasNext(w_index_hasNext),

    .r_bus_cmd(r_bus_cmd),
    .w_bus_cmd(w_bus_cmd),

    .r_dubBus_B_col(r_dubBus_B_col),
    .r_dubBus_C_col(r_dubBus_C_col),
    .r_dubBus_C_row(r_dubBus_C_row),
    .r_dubBus_S_mat(r_dubBus_S_mat),
    .r_paral_B_mat(r_paral_B_mat),
    .r_halfBus_S_col(r_halfBus_S_col),
    .r_quarterBus_U_row(r_quarterBus_U_row),

    .r_dubBus__d2(r_dubBus__d2),
    .r_paral__d2(r_paral__d2),
    .r_halfBus__d2(r_halfBus__d2),
    .r_quarterBus__d2(r_quarterBus__d2),

    .w_dubBus_B_col(w_dubBus_B_col),
    .w_dubBus_C_col(w_dubBus_C_col),
    .w_paral_B_mat(w_paral_B_mat),
    .w_halfBus_U_row(w_halfBus_U_row),

    .w_dubBus(w_dubBus),
    .w_paral(w_paral),
    .w_halfBus(w_halfBus),

    .rst(rst),
    .clk(clk)
  );

  wire [64-1:0] bus_inOp__d1;
  delay #(64) bus_inOp__ff1 (bus_inOp, bus_inOp__d1, rst, clk);
  wire [64-1:0] bus_inOp__d2;
  delay #(64) bus_inOp__ff2 (bus_inOp__d1, bus_inOp__d2, rst, clk);

  // multiplier
  wire [32-1:0] r_halfBus__d2d3;
  wire r_halfBus__doDelay = currentCmd[`MemAndMulCMD_op_CpleqStimesBT] | currentCmd[`MemAndMulCMD_op_UeqCminBtimesS];
  optionalDelay #(32) r_halfBus__ff (r_halfBus__doDelay, r_halfBus__d2, r_halfBus__d2d3, rst, clk);

  wire [16*4-1:0] m_a = (currentCmd[`MemAndMulCMD_op_CpleqStimesBT] | currentCmd[`MemAndMulCMD_op_UeqCminBtimesS]) ? r_bus__d2 : bus_inOp__d2;
  wire m_isMatrixMul1 = ~ currentCmd[`MemAndMulCMD_inOp_BpleqStimesInA];
  wire m_isPos = ~ currentCmd[`MemAndMulCMD_op_UeqCminBtimesS];
  wire [128-1:0] m_outVec;
  frodoMul m(
    .a(m_a),
    .accVec(r_dubBus__d2),
    .sCol(r_halfBus__d2d3),
    .sMat(r_dubBus__d2),
    .accMat(r_paral__d2),
    .outMat(w_paral),
    .outVec(m_outVec),
    .isMatrixMul1(m_isMatrixMul1),
    .isPos(m_isPos),
    .setStorage(m_setStorage),
    .doOp(m_doOp),
    .rst(rst),
    .clk(clk)
  );

  // simple arithmetic
  assign w_dubBus = m_outVec;
  decode8 decode(m_outVec, w_halfBus);

  wire active_rU = currentCmd[`MemAndMulCMD_op_CeqU]
                 | currentCmd[`MemAndMulCMD_op_CeqUminC] & r_which_index[0];
  wire active_rC = currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & bus_inOp_isReady
                 | currentCmd[`MemAndMulCMD_op_CeqUminC] & r_which_index[1];

  wire active_wC__a2 = (currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & bus_inOp_isReady)
                     | (currentCmd[`MemAndMulCMD_op_CeqUminC] & r_which_index[1])
                     | currentCmd[`MemAndMulCMD_op_CeqU];
  wire active_wC__a1;
  delay active_wC__ff2 (active_wC__a2, active_wC__a1, rst, clk);
  wire active_wC;
  delay active_wC__ff1 (active_wC__a1, active_wC, rst, clk);

  wire [14-1:0] index_main_update__d1 = (currentCmd[`MemAndMulCMD_op_CeqUminC] & r_which_index[1])
                                      | currentCmd[`MemAndMulCMD_op_CeqU]
                                      | (currentCmd[`MemAndMulCMD_inOp_addCRowFirst] & bus_inOp_isReady);
  wire [14-1:0] index_main_next__d1;
  wire [14-1:0] index_main = currentCmd_in_isFirstCycle ? 14'b0 : index_main_next__d1;
  wire [14-1:0] index_main_next = index_main_update__d1 ? r_index_next : index_main_next__d1;
  delay #(14) index_main_next__ff (index_main_next, index_main_next__d1, rst, clk);


  wire [4*4-1:0] r_quarterBus__d2d3;
  optionalDelay #(16) r_quarterBus__ff (currentCmd[`MemAndMulCMD_op_CeqUminC], r_quarterBus__d2, r_quarterBus__d2d3, rst, clk);
  wire [16*4-1:0] r_encoded_U__d2d3;
  encode4 encode(r_quarterBus__d2d3, r_encoded_U__d2d3);

  genvar j;
  generate
    for (j = 0; j < 4; j=j+1) begin
      assign w_bus__fromOp[j*16+:16] = currentCmd[`MemAndMulCMD_inOp_addCRowFirst]
                                     ? (r_bus__d2[j*16+:16] + bus_in[j*16+:16])
                                     : r_encoded_U__d2d3[j*16+:16] - (currentCmd[`MemAndMulCMD_op_CeqUminC] ? r_bus__d2[j*16+:16] : 16'b0);
    end
  endgenerate
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

  wire currentCMD__isOp = | (currentCmd & `MemAndMulCMD_mask_op);
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




