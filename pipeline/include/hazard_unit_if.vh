`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
  // import types
  import cpu_types_pkg::*;

  //input

  //output
  logic lw_hazard;
  logic [4:0] EX_reg;
  logic [4:0] MEM_reg;


  // hazard unit ports
  modport hu (
    output lw_hazard, EX_reg, MEM_reg
  );

endinterface

`endif
