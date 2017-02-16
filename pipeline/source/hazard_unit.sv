`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"

module hazard_unit (
	hazard_unit_if.hu huif
);

import cpu_types_pkg::*;

assign huif.EX_reg = (prif.EX_instruction_out[31:26] != RTYPE) ? prif.EX_rt_out: prif.EX_rd_out;
assign huif.MEM_reg = (prif.MEM_instruction_out[31:26] != RTYPE) ? prif.MEM_rt_out: prif.MEM_rd_out;

assign huif.lw_hazard = (prif.EX_instruction_out[31:26] == LW && (prif.EX_rt_out == prif.ID_rs_out || prif.EX_rt_out == prif.ID_rt_out)) ? 1 : 0;

always_comb begin
	case (prif.EX_instruction_out[31:26])
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
	case (prif.MEM_instruction_out[31:26])
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