`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2025 04:12:12 PM
// Design Name: 
// Module Name: frodoMul
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
module frodoMulSingle(
    input [3:0] s,
    input [15:0] a,
    output [15:0] z
  );

  wire [15:0] a1,a2,r;
  assign a1 = s[0] ? a : s[1] ? (a << 1) : {16{1'b0}};
  assign a2 = s[1]&s[0] ? (a << 1) : s[2] ? (a << 2) : {16{1'b0}};
  assign r = (a1 + a2);
  assign z = (s[3] ? -r : r);
endmodule


// mul1: *'  outVec = accVec + \sum_i sMat_i * a_i
// mul2: *"  outMat_i = accMat_i + sCol * a_i.
`ATTR_MOD_GLOBAL
module frodoMul #(
    parameter A=4,
    parameter S=8
  )(
    input [16*A-1:0] a, // 16b1x4 | 16b4x1
    input [16*S-1:0] accVec, // 16b8x1
    input [4*S-1:0] sCol, // 4b8x1
    input [4*A*S-1:0] sMat, // 4b8x4
    input [16*A*S-1:0] accMat, // 16b8x4
    output [16*A*S-1:0] outMat, // 16b8x4
    output [16*S-1:0] outVec, // 16b8x1

    input isMatrixMul1,
    input isPos,
// tt:  outVec = accVec + sMat * a
// tf:  outVec = accVec - sMat * a
// ft:  outMat = accMat + sCol * a
// ff:  outMat = accMat - sCol * a
    input setStorage, // store either accVec or sCol
    input doOp,
    
    input rst,
    input clk
  );
  genvar j;
  genvar i;

  wire  [16*S-1:0] state; // 4b or 16b vals that are 16b aligned
  wire  [16*S-1:0] state__init;
  wire  [16*S-1:0] state__new;
  wire  [16*S-1:0] state__a1 = setStorage          ? state__init
                             : doOp & isMatrixMul1 ? state__new
                                                   : state;
  delay #(16*S) state__ff (state__a1, state, rst, clk);

  generate
    for (j = 0; j < S; j=j+1) begin
      assign state__init[j*16+:16] = isMatrixMul1 ? accVec[j*16+:16] : {12'b0, sCol[j*4+:4]};
    end
  endgenerate

  wire [4*A*S-1:0] mul_op1; // b4 mul_op1[S][A]
  wire [16*A-1:0] mul_op2 = a;
  wire [16*A*S-1:0] mul_out;

  wire [4-1:0] optionalSignInverter = {~isPos, 3'b0};

  generate
    for (j = 0; j < S; j=j+1) begin
      for (i = 0; i < A; i=i+1) begin
        assign mul_op1[(j*A+i)*4+:4] = (isMatrixMul1 ? sMat[(j*A+i)*4+:4] : state[j*16+:4]) ^ optionalSignInverter;
        frodoMulSingle mul(mul_op1[(j*A+i)*4+:4], mul_op2[i*16+:16], mul_out[(j*A+i)*16+:16]);
      end
    end
  endgenerate


  wire [16*(A+1)*S-1:0] partSum;

  generate
    for (j = 0; j < S; j=j+1) begin
      assign partSum [j*(A+1)*16+:16] = state[j*16+:16];

      for (i = 0; i < A; i=i+1) begin
        assign partSum [j*(A+1)*16 + (i+1)*16+:16] = ( isMatrixMul1 ? partSum[j*(A+1)*16 + i*16+:16] : accMat[j*A*16 + i*16+:16] ) + mul_out[j*A*16 + i*16+:16];
      end

      assign state__new [j*16+:16] = partSum[j*(A+1)*16 + A*16+:16];

      assign outVec [j*16+:16] = state[j*16+:16];
      for (i = 0; i < A; i=i+1) begin
        assign outMat [(j*A+i)*16+:16] = partSum [(j*(A+1)+i+1)*16+:16];
      end
    end
  endgenerate
endmodule

