`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  aluop_t aluop;
  word_t port_a, port_b, port_out;
  logic negative, overflow, zero;

  // alu ports
  modport alu (
    input aluop, port_a, port_b,
    output port_out, negative, overflow, zero
  );
  // alu tb
  modport tb (
    input port_out, negative, overflow, zero,
    output aluop, port_a, port_b
  );
endinterface

`endif //ALU_IF_VH
