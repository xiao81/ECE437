`ifndef PROGRAM_COUNTER_IF_VH
`define PROGRAM_COUNTER_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface program_counter_if;
  // import types
  import cpu_types_pkg::*;

  logic PCEN;
  word_t npc, pc, new_pc;
  
  modport pc_port (
	input PCEN, new_pc,
	output pc, npc
  );

  modport tb (
	input pc, npc,
	output PCEN, new_pc
  );
endinterface

`endif