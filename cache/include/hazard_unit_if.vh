`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
  // import types
  import cpu_types_pkg::*;

  //input
  logic [31:0] EX_instruction_out;
  logic [31:0] MEM_instruction_out;
  //output
  logic [4:0] EX_reg;
  logic [4:0] MEM_reg;
  logic EX_forward;
  logic MEM_forward;


  // hazard unit ports
  modport hu (
    input EX_instruction_out, MEM_instruction_out,
    output  EX_reg, MEM_reg, EX_forward, MEM_forward
  );

  modport tb (
    output EX_instruction_out, MEM_instruction_out, 
    input EX_reg, MEM_reg, EX_forward, MEM_forward);

endinterface

`endif
