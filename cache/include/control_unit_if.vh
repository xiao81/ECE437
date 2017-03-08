`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  word_t instruction;
  regbits_t rs, rt, rd;
  aluop_t aluop;
  logic [IMM_W-1:0]   imm;
  logic [SHAM_W-1:0]  shamt;
  logic MemToReg, RegWEN, dWEN, dREN, halt;
  logic [1:0] RegDst;
  logic [2:0] PCSrc,ALUSrc;
  logic [1:0] regWsel;
  
  modport cu (
  	input instruction,
  	output rs, rt, rd, aluop, imm, shamt, MemToReg, RegWEN, dWEN, dREN, halt, RegDst, PCSrc, ALUSrc, regWsel
  );

  modport tb (
  	input rs, rt, rd, aluop, imm, shamt, MemToReg, RegWEN, dWEN, dREN, halt, RegDst, PCSrc, ALUSrc, regWsel,
  	output instruction
  );


endinterface
`endif
