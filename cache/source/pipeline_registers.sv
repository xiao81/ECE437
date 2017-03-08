`include "cpu_types_pkg.vh"
`include "pipeline_registers_if.vh"

module pipeline_registers
(
  input logic CLK, nRST, ihit, dhit, flush,
  pipeline_registers_if.pr prif,
  output logic enable
);

  import cpu_types_pkg::*;

  logic [31:0] MEM_instruction_reg; 
  logic [2:0] MEM_PCSrc_reg;
  logic [31:0] MEM_pc_add4_reg;
  logic MEM_RegWEN_reg;
  logic [31:0] MEM_result_reg; 
  logic [1:0] MEM_RegDst_reg; 
  logic MEM_halt_reg; 

  assign enable = (prif.EX_instruction_out[31:26] == LW || prif.EX_instruction_out[31:26] == SW) 
  ? (MEM_instruction_reg == prif.EX_instruction_out) && ihit && (!prif.MEM_halt_out)
  : ihit && (!dhit) && (!prif.MEM_halt_out);

  always_ff @(posedge CLK, negedge nRST) begin
	if(~nRST) begin
		prif.IF_instruction_out <= 0;
		prif.IF_pc_add4_out <= 0;
		prif.IF_predict_out <= 0;

		prif.ID_instruction_out <= '0;
		prif.ID_pc_add4_out <= '0;
		prif.ID_RegDst_out <= '0;
		prif.ID_RegWEN_out <= '0;
		prif.ID_aluop_out <= ALU_SLL;
		prif.ID_ALUSrc_out <= '0;
		prif.ID_regWsel_out <= '0;
		prif.ID_PCSrc_out <= '0;		
		prif.ID_dWEN_out <= '0;
		prif.ID_halt_out <= '0;
		prif.ID_rdat1_out <= '0;
		prif.ID_rdat2_out <= '0;
		prif.ID_rs_out <= '0;
		prif.ID_rt_out <= '0;
		prif.ID_rd_out <= '0;
		prif.ID_predict_out <= 0;
		

		prif.EX_instruction_out <= '0;
		prif.EX_pc_add4_out <= '0;
		prif.EX_RegWEN_out <= '0;
		prif.EX_RegDst_out <= '0;
		prif.EX_MemToReg_out <= '0;
		prif.EX_PCSrc_out <= '0;
		prif.EX_dWEN_out <= '0;
		prif.EX_dREN_out <= '0;
		prif.EX_halt_out <= '0;
		prif.EX_imm_out <= '0;
		prif.EX_shamt_out <= '0;
		prif.EX_rs_out <= '0;
		prif.EX_rt_out <= '0;
		prif.EX_rd_out <= '0;
		prif.EX_rdat1_out <= '0;
		prif.EX_rdat2_out <= '0;
		prif.EX_zero_out <= '0;
		prif.EX_port_out_out <= '0;
		prif.EX_WriteData_out <= '0;
		prif.EX_regWsel_out <= '0;
		prif.EX_result_out <= '0;
		prif.EX_predict_out <= 0;

		prif.MEM_instruction_out <= '0;
		prif.MEM_pc_add4_out <= '0;
		prif.MEM_RegWEN_out <= '0;
		prif.MEM_RegDst_out <= '0;
		prif.MEM_MemToReg_out <= '0;
		prif.MEM_PCSrc_out <= '0;
		prif.MEM_dWEN_out <= '0;
		prif.MEM_dREN_out <= '0;
		prif.MEM_halt_out <= '0;
		prif.MEM_imm_out <= '0;
		prif.MEM_shamt_out <= '0;
		prif.MEM_rs_out <= '0;
		prif.MEM_rt_out <= '0;
		prif.MEM_rd_out <= '0;
		prif.MEM_dmemload_out <= '0;
		prif.MEM_port_out_out <= '0;
		prif.MEM_ALUSrc_out <= '0;
		prif.MEM_regWsel_out <= '0;
		prif.MEM_result_out <= '0;

		MEM_instruction_reg <= '0;

	end else begin
		if(enable) begin
			if(flush) begin
				prif.IF_instruction_out <= '0;
				prif.IF_pc_add4_out <= '0;
				prif.IF_predict_out <= 0;

				prif.ID_instruction_out <= '0;
				prif.ID_pc_add4_out <= '0;			
				prif.ID_regWsel_out <= '0;
				prif.ID_PCSrc_out <= '0;
				prif.ID_dWEN_out <= '0;
				prif.ID_RegDst_out <= '0;
				prif.ID_RegWEN_out <= '0;			
				prif.ID_aluop_out <= ALU_SLL;
				prif.ID_ALUSrc_out <= '0;	
				prif.ID_halt_out <= '0;
				prif.ID_rdat1_out <= '0;
				prif.ID_rdat2_out <= '0;
				prif.ID_rs_out <= '0;
				prif.ID_rt_out <= '0;
				prif.ID_rd_out <= '0;
				prif.ID_predict_out <= 0;

				prif.EX_instruction_out <= '0;
				prif.EX_PCSrc_out <= '0;
				prif.EX_pc_add4_out <= '0;
				prif.EX_rdat2_out <= '0;
				prif.EX_regWsel_out <= '0;
				prif.EX_halt_out <= '0;
				prif.EX_dWEN_out <= '0;
				prif.EX_port_out_out <= '0;
				prif.EX_RegWEN_out <= '0;
				prif.EX_rdat1_out <= '0;
				prif.EX_RegDst_out <= '0;
				prif.EX_result_out <= '0;
				prif.EX_zero_out <= '0;
				prif.EX_WriteData_out <= '0;
				prif.EX_rs_out <= '0;
				prif.EX_rt_out <= '0;
				prif.EX_rd_out <= '0;
				prif.EX_predict_out <= 0;

				prif.MEM_instruction_out <= prif.EX_instruction_out;
				prif.MEM_PCSrc_out <= prif.EX_PCSrc_out;
				prif.MEM_halt_out <= prif.EX_halt_out;
				prif.MEM_regWsel_out <= prif.EX_regWsel_out;
				prif.MEM_dmemload_out <= prif.MEM_dmemload_in;
				prif.MEM_pc_add4_out <= prif.EX_pc_add4_out;
				prif.MEM_RegWEN_out <= prif.EX_RegWEN_out;
				prif.MEM_result_out <= prif.EX_result_out;
				prif.MEM_RegDst_out <= prif.EX_RegDst_out;
				prif.MEM_rs_out <= prif.EX_rs_out;
				prif.MEM_rt_out <= prif.EX_rt_out;
				prif.MEM_rd_out <= prif.EX_rd_out;
			end else begin
				prif.IF_instruction_out <= prif.IF_instruction_in;
				prif.IF_pc_add4_out <= prif.IF_pc_add4_in;
				prif.IF_predict_out <= prif.IF_predict_in;

				prif.ID_instruction_out <= prif.IF_instruction_out;
				prif.ID_pc_add4_out <= prif.IF_pc_add4_out;
				prif.ID_regWsel_out <= prif.ID_regWsel_in;
				prif.ID_PCSrc_out <= prif.ID_PCSrc_in;
				prif.ID_dWEN_out <= prif.ID_dWEN_in;
				prif.ID_halt_out <= prif.ID_halt_in;				
				prif.ID_rdat1_out <= prif.ID_rdat1_in;
				prif.ID_RegDst_out <= prif.ID_RegDst_in;
				prif.ID_RegWEN_out <= prif.ID_RegWEN_in;
				prif.ID_aluop_out <= prif.ID_aluop_in;
				prif.ID_ALUSrc_out <= prif.ID_ALUSrc_in;
				prif.ID_rdat2_out <= prif.ID_rdat2_in;
				prif.ID_rs_out <= prif.ID_rs_in;
				prif.ID_rt_out <= prif.ID_rt_in;
				prif.ID_rd_out <= prif.ID_rd_in;
				prif.ID_predict_out <= prif.IF_predict_out;

				prif.EX_instruction_out <= prif.ID_instruction_out;				
				prif.EX_PCSrc_out <= prif.ID_PCSrc_out;
				prif.EX_pc_add4_out <= prif.ID_pc_add4_out;
				prif.EX_regWsel_out <= prif.ID_regWsel_out;
				prif.EX_halt_out <= prif.ID_halt_out;
				prif.EX_result_out <= prif.EX_result_in;
				prif.EX_zero_out <= prif.EX_zero_in;
				prif.EX_RegDst_out <= prif.ID_RegDst_out;				
				prif.EX_WriteData_out <= prif.EX_WriteData_in;
				prif.EX_dWEN_out <= prif.ID_dWEN_out;
				prif.EX_port_out_out <= prif.EX_port_out_in;
				prif.EX_RegWEN_out <= prif.ID_RegWEN_out;
				prif.EX_rdat1_out <= prif.ID_rdat1_out;
				prif.EX_rdat2_out <= prif.ID_rdat2_out;
				prif.EX_rs_out <= prif.ID_rs_out;
				prif.EX_rt_out <= prif.ID_rt_out;
				prif.EX_rd_out <= prif.ID_rd_out;
				prif.EX_predict_out <= prif.ID_predict_out;

				MEM_instruction_reg <= '0;

				if(prif.EX_instruction_out[31:26] == LW) begin
					prif.MEM_instruction_out <= MEM_instruction_reg;
					prif.MEM_PCSrc_out <= MEM_PCSrc_reg;
					prif.MEM_pc_add4_out <= MEM_pc_add4_reg;
					prif.MEM_halt_out <= MEM_halt_reg;
					prif.MEM_dmemload_out <= prif.MEM_dmemload_reg;
					prif.MEM_regWsel_out <= prif.MEM_regWsel_reg;
					prif.MEM_RegWEN_out <= MEM_RegWEN_reg;
					prif.MEM_result_out <= MEM_result_reg;
					prif.MEM_RegDst_out <= MEM_RegDst_reg;
					prif.MEM_rs_out <= MEM_instruction_reg[25:21];
					prif.MEM_rt_out <= MEM_instruction_reg[20:16];
					prif.MEM_rd_out <= MEM_instruction_reg[15:11];
				end else begin
					prif.MEM_instruction_out <= prif.EX_instruction_out;
					prif.MEM_PCSrc_out <= prif.EX_PCSrc_out;
					prif.MEM_pc_add4_out <= prif.EX_pc_add4_out;
					prif.MEM_halt_out <= prif.EX_halt_out;
					prif.MEM_rs_out <= prif.EX_rs_out;
					prif.MEM_rt_out <= prif.EX_rt_out;
					prif.MEM_rd_out <= prif.EX_rd_out;
					prif.MEM_RegWEN_out <= prif.EX_RegWEN_out;
					prif.MEM_result_out <= prif.EX_result_out;
					prif.MEM_RegDst_out <= prif.EX_RegDst_out;
					prif.MEM_regWsel_out <= prif.EX_regWsel_out;
					prif.MEM_dmemload_out <= 32'h0000;
				end
			end
		end
		if(dhit) begin
			prif.EX_dWEN_out <= 0;
			prif.EX_regWsel_out <= '0;
			MEM_instruction_reg <= prif.EX_instruction_out;
			MEM_PCSrc_reg <= prif.EX_PCSrc_out;
			MEM_pc_add4_reg <= prif.EX_pc_add4_out;
			prif.MEM_dmemload_reg <= prif.MEM_dmemload_in;
			prif.MEM_regWsel_reg <= prif.EX_regWsel_out;
			MEM_RegWEN_reg <= prif.EX_RegWEN_out;
			MEM_result_reg <= prif.EX_result_out;
			MEM_RegDst_reg <= prif.EX_RegDst_out;
			MEM_halt_reg <= prif.EX_halt_out;
		end
	end
  end

endmodule // pipeline_registers