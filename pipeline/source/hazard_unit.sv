`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"

module hazard_unit (
	hazard_unit_if.hu huif
);

import cpu_types_pkg::*;

assign huif.EX_reg = (prif.EX_instruction_out[31:26] != RTYPE) ? prif.EX_rt_out: prif.EX_rd_out;
assign huif.MEM_reg = (prif.MEM_instruction_out[31:26] != RTYPE) ? prif.MEM_rt_out: prif.MEM_rd_out;

assign huif.lw_hazard = (prif.EX_instruction_out[31:26] == LW && (prif.EX_rt_out == prif.ID_rs_out || prif.EX_rt_out == prif.ID_rt_out)) ? 1 : 0;

endmodule