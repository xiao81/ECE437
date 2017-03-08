`include "BTB_if.vh"
`include "cpu_types_pkg.vh"


module BTB (
  input logic CLK, nRST,
  BTB_if.BTB btbif
);

import cpu_types_pkg::*;

logic btbWEN;
logic [59:0] t0,t1,t2,t3;
logic [59:0] next_t0,next_t1,next_t2,next_t3;
logic [31:0] expc;

assign btbWEN = (btbif.PCEN && (btbif.EX_instruction_out[31:26] == BEQ || btbif.EX_instruction_out[31:26] == BNE));
assign expc = btbif.EX_pc_add4_out - 4;

always_ff @(posedge CLK, negedge nRST) begin
  if (~nRST) begin
    t0 <= '0;
    t1 <= '0;
    t2 <= '0;
    t3 <= '0;
  end else if (btbWEN) begin
    t0 <= next_t0;
    t1 <= next_t1;
    t2 <= next_t2;
    t3 <= next_t3;
  end
end


always_comb begin
	btbif.branch_found = 0;
	btbif.branch_addr = '0;
	if (btbif.pc[31:4] != 0) begin
    	case(btbif.pc[3:2])
			2'b00: begin
				if (t0[59:32] == btbif.pc[31:4]) begin
				  btbif.branch_found = 1;
				  btbif.branch_addr = t0[31:0];
				end
			end
				2'b01: begin
				if (t1[59:32] == btbif.pc[31:4]) begin
				  btbif.branch_found = 1;
				  btbif.branch_addr = t1[31:0];
				end
			end
			2'b10: begin
				if (t2[59:32] == btbif.pc[31:4]) begin
				  btbif.branch_found = 1;
				  btbif.branch_addr = t2[31:0];
				end
			end
			2'b11: begin
				if (t3[59:32] == btbif.pc[31:4]) begin
				  btbif.branch_found = 1;
				  btbif.branch_addr = t3[31:0];
				end
			end
			default: begin
				btbif.branch_found = 0;
				btbif.branch_addr = '0;
			end
    	endcase
  	end
end

//write
assign next_t0 = (expc[3:2] == 2'b00) ? {expc[31:4],btbif.npc_branch} : t0;
assign next_t1 = (expc[3:2] == 2'b01) ? {expc[31:4],btbif.npc_branch} : t1;
assign next_t2 = (expc[3:2] == 2'b10) ? {expc[31:4],btbif.npc_branch} : t2;
assign next_t3 = (expc[3:2] == 2'b11) ? {expc[31:4],btbif.npc_branch} : t3;

endmodule
