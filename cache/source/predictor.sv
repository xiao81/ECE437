`include "predictor_if.vh"
`include "cpu_types_pkg.vh"

module predictor (
	input logic CLK, nRST,
	predictor_if.pi piif
);

import cpu_types_pkg::*;

logic branch;

assign branch = (piif.EX_instruction_out[31:26] == BEQ || piif.EX_instruction_out[31:26] == BEQ);
assign piif.predict = (piif.prediction_level == 2'b10 || piif.prediction_level == 2'b11);

always_ff @(posedge CLK or negedge nRST) begin : proc_
	if(~nRST) begin
		piif.prediction_level <= 0;
	end else if(piif.PCEN && branch)begin
		piif.prediction_level <= piif.next_prediction;
	end
end

always_comb begin
	case(piif.prediction_level)
		2'b00: begin
			if(piif.flush) begin
				piif.next_prediction = 2'b01;
			end else begin
				piif.next_prediction = 2'b00;
			end
		end
		2'b01: begin
			if(piif.flush) begin
				piif.next_prediction = 2'b10;
			end else begin
				piif.next_prediction = 2'b00;
			end
		end
		2'b10: begin
			if(piif.flush) begin
				piif.next_prediction = 2'b01;
			end else begin
				piif.next_prediction = 2'b11;
			end
		end
		2'b11: begin
			if(piif.flush) begin
				piif.next_prediction = 2'b10;
			end else begin
				piif.next_prediction = 2'b11;
			end
		end
		default: piif.next_prediction = 2'b00;
	endcase // piif.prediction_level
end

endmodule