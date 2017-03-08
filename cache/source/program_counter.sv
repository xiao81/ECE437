`include "program_counter_if.vh"
`include "cpu_types_pkg.vh"

module program_counter (
  input logic CLK, nRST,
  program_counter_if.pc_port pcif
);

import cpu_types_pkg::*;

always_ff @(posedge CLK, negedge nRST) begin
  if(nRST == 0) begin
    pcif.pc<= '{default:'0};
  end else begin
  	if(pcif.PCEN) begin
	  pcif.pc <= pcif.new_pc;
	end
  end
end

assign pcif.npc = pcif.pc + 4;
endmodule