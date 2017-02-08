`include "alu_if.vh"
`include "cpu_types_pkg.vh"

module alu (
  alu_if.alu aluif
);

import cpu_types_pkg::*;

always_comb begin
  aluif.overflow = 0;
  casez (aluif.aluop)
  ALU_SLL: aluif.port_out = aluif.port_a << aluif.port_b;
  ALU_SRL: aluif.port_out = aluif.port_a >> aluif.port_b;
  ALU_ADD: begin
  		   aluif.port_out = $signed(aluif.port_a) + $signed(aluif.port_b);
  		   aluif.overflow = ((aluif.port_a[31] == aluif.port_b[31]) && (aluif.port_a[31] != aluif.port_out[31]));
  		   end
  ALU_SUB: begin
  		   aluif.port_out = $signed(aluif.port_a) - $signed(aluif.port_b);
  		   aluif.overflow = ((aluif.port_a[31] != aluif.port_b[31]) && (aluif.port_a[31] != aluif.port_out[31]));
  		   end
  ALU_AND: aluif.port_out = aluif.port_a & aluif.port_b;
  ALU_OR: aluif.port_out = aluif.port_a | aluif.port_b;
  ALU_XOR: aluif.port_out = aluif.port_a ^ aluif.port_b;
  ALU_NOR: aluif.port_out = ~(aluif.port_a | aluif.port_b);
  ALU_SLT: aluif.port_out = $signed(aluif.port_a) < $signed(aluif.port_b);
  ALU_SLTU: aluif.port_out = aluif.port_a < aluif.port_b;
  default : aluif.port_out = '0;
  endcase
end

assign aluif.negative = aluif.port_out[31];
assign aluif.zero = (aluif.port_out == '0);

endmodule // alu