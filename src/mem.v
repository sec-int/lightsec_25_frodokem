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


`ATTR_MOD_GLOBAL
module bram(
  input doRead,
  input [9-1:0] read_index, // 512 values
  output [64-1:0] read_value__d2,

  input doWrite,
  input [8-1:0] write_byteEnable,
  input [9-1:0] write_index,
  input [64-1:0] write_value,

  input clk
);
`ifdef USE_BRAM_IP

  // simple dual port bram. witdth 64. depth 512. with write byte enable, 8 bits. with primitives output register, for a total read delay of two clock cycles
  blk_mem_gen_0 (
    // a is write
    .ena(doWrite),
    .wea(write_byteEnable),
    .addra(write_index),
    .dina(write_value),
    .clka(clk),
    // b is read
    .enb(doRead),
    .addrb(read_index),
    .doutb(read_value__d2),
    .clkb(clk)
  );

`else

  reg [64-1:0] mem [512-1:0];
  reg [64-1:0] out__d1;
  reg [64-1:0] out__d2;

  always @ (posedge clk) if(doWrite) begin
    if(write_byteEnable[0]) mem[write_index][0*8+:8] <= write_value[0*8+:8];
    if(write_byteEnable[1]) mem[write_index][1*8+:8] <= write_value[1*8+:8];
    if(write_byteEnable[2]) mem[write_index][2*8+:8] <= write_value[2*8+:8];
    if(write_byteEnable[3]) mem[write_index][3*8+:8] <= write_value[3*8+:8];
    if(write_byteEnable[4]) mem[write_index][4*8+:8] <= write_value[4*8+:8];
    if(write_byteEnable[5]) mem[write_index][5*8+:8] <= write_value[5*8+:8];
    if(write_byteEnable[6]) mem[write_index][6*8+:8] <= write_value[6*8+:8];
    if(write_byteEnable[7]) mem[write_index][7*8+:8] <= write_value[7*8+:8];
  end
  
  always @ (posedge clk) if(doRead)
    out__d1 <= mem[read_index];

  always @ (posedge clk)
    out__d2 <= out__d1;

  assign read_value__d2 = out__d2;

`endif
endmodule

// two interfaces: Read, Write
`ATTR_MOD_GLOBAL
module bram8(
  input [9-1:0] r_index, // 512 values
  input [8-1:0] r_bramEnable,
  input [8-1:0] r_byteEnable,
  input [8-1:0] r_fromNextIndex, // if selected, the BRAM's index is the next one
  output [64*8-1:0] r_value__d2,

  input [9-1:0] w_index,
  input [8-1:0] w_bramEnable,
  input [8-1:0] w_byteEnable,
  input [64*8-1:0] w_value,

  input rst,
  input clk
);
  genvar col;
  genvar row;

  wire [8-1:0] r_bramEnable__d1;
  delay #(8) r_bramEnable__ff1 (r_bramEnable, r_bramEnable__d1, rst, clk);
  wire [8-1:0] r_bramEnable__d2;
  delay #(8) r_bramEnable__ff2 (r_bramEnable__d1, r_bramEnable__d2, rst, clk);
  wire [8-1:0] r_byteEnable__d1;
  delay #(8) r_byteEnable__ff1 (r_byteEnable, r_byteEnable__d1, rst, clk);
  wire [8-1:0] r_byteEnable__d2;
  delay #(8) r_byteEnable__ff2 (r_byteEnable__d1, r_byteEnable__d2, rst, clk);

  wire [9*8-1:0] r_indexes;
  wire [64*8-1:0] r_rawValue__d2;
  generate
    for (col = 0; col < 8; col=col+1) begin
      assign r_indexes[col*9+:9] = r_fromNextIndex[col] ? r_index + 1 : r_index;
      
      bram mem(
        .doRead(r_bramEnable[col]),
        .read_index(r_indexes[col*9+:9]),
        .read_value__d2(r_rawValue__d2[col*64+:64]),
        .doWrite(w_bramEnable[col]),
        .write_byteEnable(w_byteEnable),
        .write_index(w_index),
        .write_value(w_value[col*64+:64]),
        .clk(clk)
      );

      for (row = 0; row < 8; row=row+1) begin
        assign r_value__d2[col*64+row*8+:8] = r_rawValue__d2[col*64+row*8+:8] & {8{ r_byteEnable__d2[row] & r_bramEnable__d2[col] }};
      end
    end
  endgenerate
endmodule

`ATTR_MOD_GLOBAL
module mem_elementIndexToByteEnable(
  input [2-1:0] elemIndex,
  output [8-1:0] byteEnable
);
  genvar i;
  generate
    for (i = 0; i < 8; i=i+1) begin
      assign byteEnable[i] = elemIndex == (i >> 1);
    end
  endgenerate
endmodule

`ATTR_MOD_GLOBAL
module mem_byteIndexToByteEnable(
  input [3-1:0] byteIndex,
  output [8-1:0] byteEnable
);
  genvar i;
  generate
    for (i = 0; i < 8; i=i+1) begin
      assign byteEnable[i] = byteIndex == i;
    end
  endgenerate
endmodule

`define MainMem_OFF_B		9'd0
`define MainMem_OFF_S		(`MainMem_OFF_B + 9'd336)
`define MainMem_OFF_SSState	(`MainMem_OFF_S + 9'd84)
`define MainMem_OFF_C		(`MainMem_OFF_SSState + 9'd4)
`define MainMem_OFF_RNGState	(`MainMem_OFF_C + 9'd2)
`define MainMem_OFF_salt	(`MainMem_OFF_RNGState + 9'd1)
`define MainMem_OFF_seedSE	(`MainMem_OFF_salt + 9'd1)
`define MainMem_OFF_pkh		(`MainMem_OFF_seedSE + 9'd1)
`define MainMem_OFF_U		(`MainMem_OFF_pkh + 9'd1)
`define MainMem_OFF_k		(`MainMem_OFF_U + 9'd1)

// it connects two side: Outside, Inside
`ATTR_MOD_GLOBAL
module mainMem_readConnector(
    input [14-1:0] o_index,
    output [14-1:0] o_index_next,
    output o_index_hasNext,

    input o_bus_B_row, // row first, 16b1x4
    input o_bus_B_col, // col first, 16b4x1
    input o_bus_C_row, // row first, 16b1x4
    input o_bus_SSState, // 64b
    input o_bus_RNGState, // 64b
    input o_bus_salt, // 64b
    input o_bus_seedSE, // 64b
    input o_bus_pkh, // 64b
    input o_bus_k, // 64b
    input o_bus_U_twoRows, // 4b2x8
    output [16*4-1:0] o_bus__d2,

    input o_dubBus_B_col, // 16b8x1
    input o_dubBus_C_col, // 16b8x1
    input o_dubBus_C_row, // 16b1x8
    input o_dubBus_S_mat, // 4b8x4
    output [16*8-1:0] o_dubBus__d2,

    input o_paral_B_mat, // 16b8x4
    output [16*4*8-1:0] o_paral__d2,

    input o_halfBus_S_col, // 4b8x1
    output [4*8-1:0] o_halfBus__d2,

    input o_quarterBus_U_row, // 4b4x1
    output [4*4-1:0] o_quarterBus__d2,

    output [9-1:0] i_index, // 512 values
    output [8-1:0] i_bramEnable,
    output [8-1:0] i_byteEnable,
    output [8-1:0] i_fromNextIndex, // if selected, the BRAM's index is the next one
    input [64*8-1:0] i_value__d2
);
  wire [9-1:0] column_offset = (o_bus_B_row | o_bus_B_col | o_dubBus_B_col | o_paral_B_mat) ? `MainMem_OFF_B : 9'd0
                             | (o_dubBus_S_mat | o_halfBus_S_col) ? `MainMem_OFF_S : 9'd0
                             | o_bus_SSState ? `MainMem_OFF_SSState : 9'd0
                             | (o_bus_C_row | o_dubBus_C_col | o_dubBus_C_row) ? `MainMem_OFF_C : 9'd0
                             | o_bus_RNGState ? `MainMem_OFF_RNGState : 9'd0
                             | o_bus_salt ? `MainMem_OFF_salt : 9'd0
                             | o_bus_seedSE ? `MainMem_OFF_seedSE : 9'd0
                             | o_bus_pkh ? `MainMem_OFF_pkh : 9'd0
                             | (o_bus_U_twoRows | o_quarterBus_U_row) ? `MainMem_OFF_U : 9'd0
                             | o_bus_k ? `MainMem_OFF_k : 9'd0;


  assign o_index_next = (o_bus_B_row & (o_index[0+:9] == 9'd335)) ? { o_index[14-1:9] + 1, 9'b0 }
                                                                  : o_index + 14'b1;

  assign o_index_hasNext = (o_bus_B_row ? o_index != {5'd7, 9'd335} : 1'b0)
                         | (o_bus_B_col ? o_index != 14'd2687 : 1'b0) 
                         | ((o_bus_C_row | o_quarterBus_U_row) ? o_index != 14'd15 : 1'b0) 
                         | (o_bus_SSState ? o_index != 14'd24 : 1'b0) 
                         | (o_bus_RNGState ? o_index != 14'd7 : 1'b0) 
                         | (o_bus_salt ? o_index != 14'd7 : 1'b0)
                         | (o_bus_seedSE ? o_index != 14'd7 : 1'b0)
                         | (o_bus_pkh ? o_index != 14'd3 : 1'b0)
                         | (o_bus_k ? o_index != 14'd3 : 1'b0)
                         | ((o_dubBus_B_col | o_halfBus_S_col) ? o_index != 14'd1343 : 1'b0)
                         | ((o_dubBus_C_col | o_dubBus_C_row) ? o_index != 14'd7 : 1'b0)
                         | (o_bus_U_twoRows ? o_index != 14'd3 : 1'b0) 
                         | ((o_paral_B_mat | o_dubBus_S_mat) ? o_index != 14'd335 : 1'b0);

  wire o_bus_anyCell = o_bus_SSState
                     | o_bus_RNGState
                     | o_bus_salt
                     | o_bus_seedSE
                     | o_bus_pkh
                     | o_bus_k
                     | o_bus_U_twoRows;

  wire o_dubBus_anyCol = o_dubBus_C_col
                       | o_dubBus_B_col
                       | o_dubBus_S_mat;

  wire [9-1:0] unoff_index_col = (o_bus_B_row | o_paral_B_mat) ? o_index[0+:9] : 9'b0
                               | o_bus_C_row ? {8'b0, o_index[0+:1]} : 9'b0
                               | o_dubBus_anyCol ? o_index[2+:9] : 9'b0
                               | (o_bus_B_col | o_bus_anyCell) ? o_index[3+:9] : 9'b0
                               | o_halfBus_S_col ? o_index[4+:9] : 9'b0;

  assign i_index = unoff_index_col + column_offset;


  wire [2-1:0] i_byteEnable_elemIndex = ((o_dubBus_anyCol | o_quarterBus_U_row) ? o_index[0+:2] : 2'b0)
                                      | (o_bus_B_col ? o_index[1+:2] : 2'b0);
  wire [8-1:0] i_byteEnable_elem;
  mem_elementIndexToByteEnable i_byteEnable_elem__c (i_byteEnable_elemIndex, i_byteEnable_elem);
  
  wire [3-1:0] i_byteEnable_byteIndex = (o_halfBus_S_col ? o_index[1+:3] : 3'b0);
  wire [8-1:0] i_byteEnable_byte;
  mem_byteIndexToByteEnable i_byteEnable_byte__c (i_byteEnable_byteIndex, i_byteEnable_byte);

  assign i_byteEnable = (o_bus_B_row | o_bus_C_row | o_paral_B_mat | o_bus_anyCell | o_dubBus_C_row) ? 8'hFF : 8'b0
                      | (o_dubBus_anyCol | o_bus_B_col | o_quarterBus_U_row) ? i_byteEnable_elem : 8'b0
                      | o_halfBus_S_col ? i_byteEnable_byte : 8'b0;


  wire [2-1:0] i_bramEnable_elemIndex = (o_dubBus_C_row ? o_index[1+:2] : 2'b0);
  wire [8-1:0] i_bramEnable_elem;
  mem_elementIndexToByteEnable i_bramEnable_elem__c (i_bramEnable_elemIndex, i_bramEnable_elem);
  
  wire [3-1:0] i_bramEnable_byteIndex = (o_bus_B_row ? o_index[9+:3] : 3'b0)
                                      | (o_bus_C_row ? (o_index[9+:3] ^ {2'b0, o_index[0]}) : 3'b0)
                                      | (o_bus_anyCell ? o_index[0+:3] : 3'b0)
                                      | (o_quarterBus_U_row ? o_index[2+:3] : 3'b0);
  wire [8-1:0] i_bramEnable_byte;
  mem_byteIndexToByteEnable i_bramEnable_byte__c (i_bramEnable_byteIndex, i_bramEnable_byte);

  assign i_bramEnable = (o_halfBus_S_col | o_dubBus_B_col | o_dubBus_C_col | o_dubBus_S_mat | o_paral_B_mat) ? 8'b11111111 : 8'b0
                      | o_bus_B_col ? (o_index[0] == 1'b0 ? 8'b00001111 : 8'b11110000) : 8'b0
                      | o_dubBus_C_row ? i_bramEnable_elem : 8'b0
                      | (o_bus_B_row | o_bus_C_row | o_bus_anyCell | o_quarterBus_U_row) ? i_bramEnable_byte : 8'b0;


  wire [3-1:0] i_fromNextIndex_byteIndex = i_index[0+:3] ^ 3'b001;
  wire [8-1:0] i_fromNextIndex_byte;
  mem_byteIndexToByteEnable i_fromNextIndex_byte__c(i_fromNextIndex_byteIndex, i_fromNextIndex_byte);
  assign i_fromNextIndex = {8{o_dubBus_C_row}} & i_fromNextIndex_byte;


  genvar row;
  genvar col;


  assign o_paral__d2 = i_value__d2;


  wor [16*8-1:0] mergeCol__d2;
  wire [16*8-1:0] mergeCol_swapped__d2; // swap following pairs of rows in the column
  wor [16*4*2-1:0] mergeTwoRows__d2;
  generate
    for (row = 0; row < 8; row=row+1) begin
      for (col = 0; col < 4; col=col+1) begin
        assign mergeCol__d2[row*16+:16] = i_value__d2[row*64+col*16+:16];
      end

      assign mergeCol_swapped__d2[row*16+:16] = mergeCol__d2[(row^1)*16+:16];
    end

    for (col = 0; col < 4; col=col+1) begin
      assign mergeTwoRows__d2 = i_value__d2[col*128+:128];
    end
  endgenerate

  assign o_dubBus__d2 = (o_dubBus_C_row & ~o_index[0]) ? mergeTwoRows__d2
                      : (o_dubBus_C_row & o_index[0])  ? {mergeTwoRows__d2[0+:64], mergeTwoRows__d2[64+:64]}
                      : (o_dubBus_C_col & o_index[2])  ? mergeCol_swapped__d2
                                                       : mergeCol__d2;

  wire [64-1:0] mergeRow__d2 = mergeTwoRows__d2[0+:64] | mergeTwoRows__d2[64+:64];
  assign o_bus__d2 = o_bus_B_col
                   ? (mergeCol__d2[0+:16*4] | mergeCol__d2[16*4+:16*4])
                   : mergeRow__d2;

  assign o_quarterBus__d2 = mergeRow__d2[0+:16] | mergeRow__d2[16+:16] | mergeRow__d2[32+:16] | mergeRow__d2[48+:16];

  wire o_halfBus_shift = o_index[0];
  wire [8*8-1:0] mergeByteCol__d2;
  generate
    for (row = 0; row < 8; row=row+1) begin
      assign mergeByteCol__d2[row*8+:8] = mergeCol__d2[row*16+:8] | mergeCol__d2[row*16+8+:8];
      assign o_halfBus__d2[row*4+:4] = mergeByteCol__d2[row*8+o_halfBus_shift*4+:4];
    end
  endgenerate
endmodule

`ATTR_MOD_GLOBAL
module stdToCompact_single(
  input [16-1:0] in,
  output [4-1:0] out
);
  assign out[3] = in[15]; // isNeg
  assign out[2:0] = in[15] ? -in[2:0] : in[2:0];
endmodule

`ATTR_MOD_GLOBAL
module stdToCompact(
    input [64-1:0] in,
    output [16-1:0] out
  );
  stdToCompact_single s0(in[16*0+:16], out[4*0+:4]);
  stdToCompact_single s1(in[16*1+:16], out[4*1+:4]);
  stdToCompact_single s2(in[16*2+:16], out[4*2+:4]);
  stdToCompact_single s3(in[16*3+:16], out[4*3+:4]);
endmodule


// it connects two side: Outside, Inside
`ATTR_MOD_GLOBAL
module mainMem_writeConnector(
    input [14-1:0] o_index,
    output [14-1:0] o_index_next,
    output o_index_hasNext,

    input o_bus_B_row, // row first, 16b1x4
    input o_bus_B_col, // col first, 16b4x1
    input o_bus_C_row, // row first, 16b1x4
    input o_bus_SSState, // 64b
    input o_bus_RNGState, // 64b
    input o_bus_salt, // 64b
    input o_bus_seedSE, // 64b
    input o_bus_pkh, // 64b
    input o_bus_k, // 64b
    input o_bus_U_twoRows, // 4b2x8
    input o_bus_S_row, // row first, 4b1x4
    input [16*4-1:0] o_bus, 

    input o_dubBus_B_col, // 16b8x1
    input o_dubBus_C_col, // 16b8x1
    input [16*8-1:0] o_dubBus,

    input o_paral_B_mat, // 16b8x4
    input [16*4*8-1:0] o_paral,

    input o_halfBus_U_row, // 4b1x8
    input [4*8-1:0] o_halfBus,

    output [9-1:0] i_index, // 512 values
    output [8-1:0] i_bramEnable,
    output [8-1:0] i_byteEnable,
    output [64*8-1:0] i_value
);
  wire [9-1:0] column_offset = (o_bus_B_row | o_bus_B_col | o_dubBus_B_col | o_paral_B_mat) ? `MainMem_OFF_B : 9'd0
                             | o_bus_S_row ? `MainMem_OFF_S : 9'd0
                             | o_bus_SSState ? `MainMem_OFF_SSState : 9'd0
                             | (o_bus_C_row | o_dubBus_C_col) ? `MainMem_OFF_C : 9'd0
                             | o_bus_RNGState ? `MainMem_OFF_RNGState : 9'd0
                             | o_bus_salt ? `MainMem_OFF_salt : 9'd0
                             | o_bus_seedSE ? `MainMem_OFF_seedSE : 9'd0
                             | o_bus_pkh ? `MainMem_OFF_pkh : 9'd0
                             | (o_halfBus_U_row | o_bus_U_twoRows) ? `MainMem_OFF_U : 9'd0
                             | o_bus_k ? `MainMem_OFF_k : 9'd0;

  assign o_index_next = (o_bus_B_row & (o_index[0+:9] == 9'd335))   ? { o_index[14-1:9] + 1, 9'b0 }
                      : (o_bus_S_row & (o_index[0+:11] == 11'd335)) ? { o_index[14-1:11] + 1, 11'b0 }
                                                                    : o_index + 14'b1;

  assign o_index_hasNext = ((o_bus_S_row | o_bus_B_row) ? o_index != {5'd7, 9'd335} : 1'b0)
                         | (o_bus_B_col ? o_index != 14'd2687 : 1'b0) 
                         | (o_bus_C_row ? o_index != 14'd15 : 1'b0) 
                         | (o_bus_SSState ? o_index != 14'd24 : 1'b0) 
                         | (o_bus_RNGState ? o_index != 14'd7 : 1'b0) 
                         | (o_bus_salt ? o_index != 14'd7 : 1'b0)
                         | (o_bus_seedSE ? o_index != 14'd7 : 1'b0)
                         | (o_bus_pkh ? o_index != 14'd3 : 1'b0)
                         | (o_bus_k ? o_index != 14'd3 : 1'b0)
                         | (o_dubBus_B_col ? o_index != 14'd1343 : 1'b0)
                         | ((o_dubBus_C_col | o_halfBus_U_row) ? o_index != 14'd7 : 1'b0)
                         | (o_bus_U_twoRows ? o_index != 14'd3 : 1'b0) 
                         | (o_paral_B_mat ? o_index != 14'd335 : 1'b0);

  wire o_bus_anyCell = o_bus_SSState
                     | o_bus_RNGState
                     | o_bus_salt
                     | o_bus_seedSE
                     | o_bus_pkh
                     | o_bus_k
                     | o_bus_U_twoRows;

  wire o_dubBus_anyCol = o_dubBus_C_col
                       | o_dubBus_B_col;

  wire [9-1:0] unoff_index_col = (o_bus_B_row | o_paral_B_mat) ? o_index[0+:9] : 9'b0
                               | o_bus_C_row ? {8'b0, o_index[0+:1]} : 9'b0
                               | (o_dubBus_anyCol | o_bus_S_row) ? o_index[2+:9] : 9'b0
                               | (o_bus_B_col | o_bus_anyCell) ? o_index[3+:9] : 9'b0
                               | o_halfBus_U_row ? o_index[4+:9] : 9'b0;


  assign i_index = unoff_index_col + column_offset;


  wire [2-1:0] i_byteEnable_elemIndex = ((o_dubBus_anyCol | o_bus_S_row) ? o_index[0+:2] : 2'b0)
                                      | (o_bus_B_col ? o_index[1+:2] : 2'b0);
  wire [8-1:0] i_byteEnable_elem;
  mem_elementIndexToByteEnable i_byteEnable_elem__c(i_byteEnable_elemIndex, i_byteEnable_elem);
  
  assign i_byteEnable = (o_bus_B_row | o_bus_C_row | o_paral_B_mat | o_bus_anyCell) ? 8'hFF : 8'b0
                      | o_halfBus_U_row ? (o_index[0] == 1'b0 ? 8'h0F : 8'hF0) : 8'b0
                      | (o_dubBus_anyCol | o_bus_S_row | o_bus_B_col) ? i_byteEnable_elem : 8'b0;


  wire [3-1:0] i_bramEnable_byteIndex = (o_bus_B_row ? o_index[9+:3] : 3'b0)
                                      | (o_bus_C_row ? (o_index[1+:3] ^ {2'b0, o_index[0]}) : 3'b0) // TODO Why is the get a 9+:3?
                                      | (o_bus_S_row ? o_index[11+:3] : 3'b0)
                                      | (o_halfBus_U_row ? o_index[1+:3] : 3'b0)
                                      | (o_bus_anyCell ? o_index[0+:3] : 3'b0);
  wire [8-1:0] i_bramEnable_byte;
  mem_byteIndexToByteEnable i_bramEnable_byte__c(i_bramEnable_byteIndex, i_bramEnable_byte);

  assign i_bramEnable = (o_dubBus_B_col | o_dubBus_C_col | o_paral_B_mat) ? 8'b11111111 : 8'b0
                      | o_bus_B_col ? (o_index[0] == 1'b0 ? 8'b00001111 : 8'b11110000) : 8'b0
                      | (o_bus_B_row | o_bus_C_row | o_bus_anyCell | o_halfBus_U_row | o_bus_S_row) ? i_bramEnable_byte : 8'b0;


  genvar row;
  genvar col;

  wor [64*8-1:0] i_value__w;
  assign i_value = i_value__w;

  generate
    for (row = 0; row < 8; row=row+1) begin
      assign i_value__w[row*64+:64] = o_dubBus_B_col ? {4{o_dubBus[row*16+:16]}} : 64'b0;
      assign i_value__w[row*64+:64] = o_dubBus_C_col ? (o_index[2] ? {4{o_dubBus[(row^1)*16+:16]}} : {4{o_dubBus[row*16+:16]}}) : 64'b0;
    end
  endgenerate

  assign i_value__w = o_paral_B_mat ? o_paral : 512'b0;
  assign i_value__w = (o_bus_B_row | o_bus_C_row | o_bus_anyCell) ? {8{o_bus}} : 512'b0;

  generate
    for (row = 0; row < 4; row=row+1) begin
      assign i_value__w[0*64+row*64+:64] = o_bus_B_col ? {4{o_bus[row*16+:16]}} : 64'b0;
      assign i_value__w[4*64+row*64+:64] = o_bus_B_col ? {4{o_bus[row*16+:16]}} : 64'b0;
    end
  endgenerate

  assign i_value__w = o_halfBus_U_row ? {16{o_halfBus}} : 512'b0;
  
  wire [16-1:0] o_bus_sampledCompact;
  stdToCompact o_bus_sampledCompact__c (o_bus, o_bus_sampledCompact);
  
  assign i_value__w = o_bus_S_row ? {4*8{o_bus_sampledCompact}} : 512'b0;
endmodule

`define MainMemCMD_bus_B_row 0
`define MainMemCMD_bus_B_col 1
`define MainMemCMD_bus_C_row 2
`define MainMemCMD_bus_SSState 3
`define MainMemCMD_bus_RNGState 4
`define MainMemCMD_bus_salt 5
`define MainMemCMD_bus_seedSE 6
`define MainMemCMD_bus_pkh 7
`define MainMemCMD_bus_k 8
`define MainMemCMD_bus_U_twoRows 9
`define MainMemCMD_bus_S_row 10 /* only the lowest 16bits are used, only for writing */

`define MainMemCMD_SIZE 11


// two interfaces: Read, Write
`ATTR_MOD_GLOBAL
module mainMem(
    input [14-1:0] r_index,
    output [14-1:0] r_index_next,
    output r_index_hasNext,

    input [`MainMemCMD_SIZE-1:0] r_bus_cmd, // no MainMemCMD_bus_S_row!
    output [16*4-1:0] r_bus__d2,

    input r_dubBus_B_col, // 16b8x1
    input r_dubBus_C_col, // 16b8x1
    input r_dubBus_C_row, // 16b1x8
    input r_dubBus_S_mat, // 4b8x4
    output [16*8-1:0] r_dubBus__d2,

    input r_paral_B_mat, // 16b8x4
    output [16*4*8-1:0] r_paral__d2,

    input r_halfBus_S_col, // 4b8x1
    output [4*8-1:0] r_halfBus__d2,

    input r_quarterBus_U_row, // 4b4x1
    output [4*4-1:0] r_quarterBus__d2,
 

    input [14-1:0] w_index,
    output [14-1:0] w_index_next,
    output w_index_hasNext,

    input [`MainMemCMD_SIZE-1:0] w_bus_cmd,
    input [16*4-1:0] w_bus, 

    input w_dubBus_B_col, // 16b8x1
    input w_dubBus_C_col, // 16b8x1
    input [16*8-1:0] w_dubBus,

    input w_paral_B_mat, // 16b8x4
    input [16*4*8-1:0] w_paral,

    input w_halfBus_U_row, // 4b1x8
    input [4*8-1:0] w_halfBus,

    input rst,
    input clk
  );

  wire [9-1:0] b__r_index;
  wire [8-1:0] b__r_bramEnable;
  wire [8-1:0] b__r_byteEnable;
  wire [8-1:0] b__r_fromNextIndex;
  wire [64*8-1:0] b__r_value__d2;
  wire [9-1:0] b__w_index;
  wire [8-1:0] b__w_bramEnable;
  wire [8-1:0] b__w_byteEnable;
  wire [64*8-1:0] b__w_value;
  bram8 b(
    .r_index(b__r_index),
    .r_bramEnable(b__r_bramEnable),
    .r_byteEnable(b__r_byteEnable),
    .r_fromNextIndex(b__r_fromNextIndex),
    .r_value__d2(b__r_value__d2),
    .w_index(b__w_index),
    .w_bramEnable(b__w_bramEnable),
    .w_byteEnable(b__w_byteEnable),
    .w_value(b__w_value),
    .rst(rst),
    .clk(clk)
  );

  wire ignore = r_bus_cmd[`MainMemCMD_bus_S_row];
  mainMem_readConnector r(
    .o_index(r_index),
    .o_index_next(r_index_next),
    .o_index_hasNext(r_index_hasNext),
    .o_bus_B_row(r_bus_cmd[`MainMemCMD_bus_B_row]),
    .o_bus_B_col(r_bus_cmd[`MainMemCMD_bus_B_col]),
    .o_bus_C_row(r_bus_cmd[`MainMemCMD_bus_C_row]),
    .o_bus_SSState(r_bus_cmd[`MainMemCMD_bus_SSState]),
    .o_bus_RNGState(r_bus_cmd[`MainMemCMD_bus_RNGState]),
    .o_bus_salt(r_bus_cmd[`MainMemCMD_bus_salt]),
    .o_bus_seedSE(r_bus_cmd[`MainMemCMD_bus_seedSE]),
    .o_bus_pkh(r_bus_cmd[`MainMemCMD_bus_pkh]),
    .o_bus_k(r_bus_cmd[`MainMemCMD_bus_k]),
    .o_bus_U_twoRows(r_bus_cmd[`MainMemCMD_bus_U_twoRows]),
    .o_bus__d2(r_bus__d2),
    .o_dubBus_B_col(r_dubBus_B_col),
    .o_dubBus_C_col(r_dubBus_C_col),
    .o_dubBus_C_row(r_dubBus_C_row),
    .o_dubBus_S_mat(r_dubBus_S_mat),
    .o_dubBus__d2(r_dubBus__d2),
    .o_paral_B_mat(r_paral_B_mat),
    .o_paral__d2(r_paral__d2),
    .o_halfBus_S_col(r_halfBus_S_col),
    .o_halfBus__d2(r_halfBus__d2),
    .o_quarterBus_U_row(r_quarterBus_U_row),
    .o_quarterBus__d2(r_quarterBus__d2),
    .i_index(b__r_index),
    .i_bramEnable(b__r_bramEnable),
    .i_byteEnable(b__r_byteEnable),
    .i_fromNextIndex(b__r_fromNextIndex),
    .i_value__d2(b__r_value__d2)
  );

  mainMem_writeConnector w(
    .o_index(w_index),
    .o_index_next(w_index_next),
    .o_index_hasNext(w_index_hasNext),
    .o_bus_B_row(w_bus_cmd[`MainMemCMD_bus_B_row]),
    .o_bus_B_col(w_bus_cmd[`MainMemCMD_bus_B_col]),
    .o_bus_C_row(w_bus_cmd[`MainMemCMD_bus_C_row]),
    .o_bus_SSState(w_bus_cmd[`MainMemCMD_bus_SSState]),
    .o_bus_RNGState(w_bus_cmd[`MainMemCMD_bus_RNGState]),
    .o_bus_salt(w_bus_cmd[`MainMemCMD_bus_salt]),
    .o_bus_seedSE(w_bus_cmd[`MainMemCMD_bus_seedSE]),
    .o_bus_pkh(w_bus_cmd[`MainMemCMD_bus_pkh]),
    .o_bus_k(w_bus_cmd[`MainMemCMD_bus_k]),
    .o_bus_U_twoRows(w_bus_cmd[`MainMemCMD_bus_U_twoRows]),
    .o_bus_S_row(w_bus_cmd[`MainMemCMD_bus_S_row]),
    .o_bus(w_bus),
    .o_dubBus_B_col(w_dubBus_B_col),
    .o_dubBus_C_col(w_dubBus_C_col),
    .o_dubBus(w_dubBus),
    .o_paral_B_mat(w_paral_B_mat),
    .o_paral(w_paral),
    .o_halfBus_U_row(w_halfBus_U_row),
    .o_halfBus(w_halfBus),
    .i_index(b__w_index),
    .i_bramEnable(b__w_bramEnable),
    .i_byteEnable(b__w_byteEnable),
    .i_value(b__w_value)
  );

endmodule

