`ifndef BTB_IF_VH
`define BTB_IF_VH

`include "cpu_types_pkg.vh"
interface BTB_if;

// import types
  import cpu_types_pkg::*;

  //input
  logic [31:0] pc;
  logic [31:0] EX_pc_add4_out;
  logic [31:0] EX_instruction_out;
  logic PCEN;
  logic [31:0] npc_branch;

  //output
  logic branch_found; //the branch index found
  logic [31:0] branch_addr;

  modport BTB (
    input pc, EX_pc_add4_out, EX_instruction_out, PCEN, npc_branch, 
    output branch_found, branch_addr);

endinterface

`endif
