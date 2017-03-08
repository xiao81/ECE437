`ifndef PREDICTOR_IF_VH
`define PREDICTOR_IF_VH

`include "cpu_types_pkg.vh"
interface predictor_if ();
	import cpu_types_pkg::*;

	//input 
	word_t EX_instruction_out;
	logic PCEN;
	logic flush;
	//output
	logic [1:0] prediction_level;
	logic [1:0] next_prediction;
	logic predict;

	modport pi (
		input EX_instruction_out, PCEN, flush, 
		output prediction_level, next_prediction, predict);
endinterface

`endif