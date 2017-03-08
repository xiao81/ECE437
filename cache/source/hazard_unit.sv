`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"

module hazard_unit (
	hazard_unit_if.hu huif
);

import cpu_types_pkg::*;

assign huif.EX_reg = (huif.EX_instruction_out[31:26] != RTYPE) ? huif.EX_instruction_out[20:16] : huif.EX_instruction_out[15:11];
assign huif.MEM_reg = (huif.MEM_instruction_out[31:26] != RTYPE) ? huif.MEM_instruction_out[20:16] : huif.MEM_instruction_out[15:11];

always_comb begin
	case (huif.EX_instruction_out[31:26])
		BEQ: begin
			huif.EX_forward = 0;
		end
		BNE: begin
			huif.EX_forward = 0;
		end
		J: begin
			huif.EX_forward = 0;
		end
		JAL: begin
			huif.EX_forward = 0;
		end
		SW: begin
			huif.EX_forward = 0;
		end
		default : huif.EX_forward = 1;
	endcase
	case (huif.MEM_instruction_out[31:26])
		BEQ: begin
			huif.MEM_forward = 0;
		end
		BNE: begin
			huif.MEM_forward = 0;
		end
		J: begin
			huif.MEM_forward = 0;
		end
		JAL: begin
			huif.MEM_forward = 0;
		end
		SW: begin
			huif.MEM_forward = 0;
		end
		default : huif.MEM_forward = 1;
	endcase
end
endmodule