`include "cpu_types_pkg.vh"
`include "pipeline_registers_if.vh"

module pipeline_registers
(
  input logic CLK, nRST, ihit, dhit,
  pipeline_registers_if.pr prif
);

  import cpu_types_pkg::*;

  always_ff @(posedge CLK or negedge nRST) begin : proc_
  	if(~nRST) begin
  		prif.IF_instruction_out <= 0;
  		prif.IF_pc_add4_out <= 0;

  		prif.ID_instruction_out <= '0;
	    prif.ID_pc_add4_out <= '0;
	    prif.ID_RegWEN_out <= '0;
	    prif.ID_RegDst_out <= '0;
	    prif.ID_MemToReg_out <= '0;
	    prif.ID_PCSrc_out <= '0;
	    prif.ID_ALUSrc_out <= '0;
	    prif.ID_dWEN_out <= '0;
	    prif.ID_dREN_out <= '0;
	    prif.ID_halt_out <= '0;
	    prif.ID_aluop_out <= ALU_SLL;
	    prif.ID_imm_out <= '0;
	    prif.ID_shamt_out <= '0;
	    prif.ID_rs_out <= '0;
	    prif.ID_rt_out <= '0;
	    prif.ID_rd_out <= '0;
	    prif.ID_rdat1_out <= '0;
	    prif.ID_rdat2_out <= '0;

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
		prif.EX_rdat2_out <= '0;
		prif.EX_zero_out <= '0;
		prif.EX_port_out_out <= '0;
		prif.EX_new_pc_out <= '0;

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

  	end else begin
  		if(ihit & ~dhit) begin
	  		prif.IF_instruction_out <= prif.IF_instruction_in;
	  		prif.IF_pc_add4_out <= prif.IF_pc_add4_in;

	  		prif.ID_instruction_out <= prif.IF_instruction_out;
		    prif.ID_pc_add4_out <= prif.IF_pc_add4_out;
		    prif.ID_RegWEN_out <= prif.ID_RegWEN_in;
		    prif.ID_RegDst_out <= prif.ID_RegDst_in;
		    prif.ID_MemToReg_out <= prif.ID_MemToReg_in;
		    prif.ID_PCSrc_out <= prif.ID_PCSrc_in;
		    prif.ID_ALUSrc_out <= prif.ID_ALUSrc_in;
		    prif.ID_dWEN_out <= prif.ID_dWEN_in;
		    prif.ID_dREN_out <= prif.ID_dREN_in;
		    prif.ID_halt_out <= prif.ID_halt_in;
		    prif.ID_aluop_out <= prif.ID_aluop_in;
		    prif.ID_imm_out <= prif.ID_imm_in;
		    prif.ID_shamt_out <= prif.ID_shamt_in;
		    prif.ID_rs_out <= prif.ID_rs_in;
		    prif.ID_rt_out <= prif.ID_rt_in;
		    prif.ID_rd_out <= prif.ID_rd_in;
		    prif.ID_rdat1_out <= prif.ID_rdat1_in;
		    prif.ID_rdat2_out <= prif.ID_rdat2_in;

		    prif.EX_instruction_out <= prif.ID_instruction_out;
			prif.EX_pc_add4_out <= prif.ID_pc_add4_out;
			prif.EX_RegWEN_out <= prif.ID_RegWEN_out;
			prif.EX_RegDst_out <= prif.ID_RegDst_out;
			prif.EX_MemToReg_out <= prif.ID_MemToReg_out;
			prif.EX_PCSrc_out <= prif.ID_PCSrc_out;
			prif.EX_dWEN_out <= prif.ID_dWEN_out;
			prif.EX_dREN_out <= prif.ID_dREN_out;
			prif.EX_halt_out <= prif.ID_halt_out;
			prif.EX_imm_out <= prif.ID_imm_out;
			prif.EX_shamt_out <= prif.ID_shamt_out;
			prif.EX_rs_out <= prif.ID_rs_out;
			prif.EX_rt_out <= prif.ID_rt_out;
			prif.EX_rd_out <= prif.ID_rd_out;
			prif.EX_rdat2_out <= prif.ID_rdat2_out;
			prif.EX_zero_out <= prif.EX_zero_in;
			prif.EX_port_out_out <= prif.EX_port_out_in;
			prif.EX_new_pc_out <= prif.EX_new_pc_in;

			prif.MEM_instruction_out <= prif.EX_instruction_out;
			prif.MEM_pc_add4_out <= prif.EX_pc_add4_out;
			prif.MEM_RegWEN_out <= prif.EX_RegWEN_out;
			prif.MEM_RegDst_out <= prif.EX_RegDst_out;
			prif.MEM_MemToReg_out <= prif.EX_MemToReg_out;
			prif.MEM_PCSrc_out <= prif.EX_PCSrc_out;
			prif.MEM_dWEN_out <= prif.EX_dWEN_out;
			prif.MEM_dREN_out <= prif.EX_dREN_out;
			prif.MEM_halt_out <= prif.EX_halt_out;
			prif.MEM_imm_out <= prif.EX_imm_out;
			prif.MEM_shamt_out <= prif.EX_shamt_out;
			prif.MEM_rs_out <= prif.EX_rs_out;
			prif.MEM_rt_out <= prif.EX_rt_out;
			prif.MEM_rd_out <= prif.EX_rd_out;
			prif.MEM_dmemload_out <= prif.MEM_dmemload_in;
			prif.MEM_port_out_out <= prif.EX_port_out_out;
		end
		if(dhit) begin
			prif.EX_dWEN_out <= 0;
			//regwdatasel
			prif.MEM_instruction_out <= prif.EX_instruction_out;
			prif.MEM_PCSrc_out <= prif.EX_PCSrc_out;
			prif.MEM_pc_add4_out <= prif.EX_pc_add4_out;
			prif.MEM_dmemload_out <= prif.MEM_dmemload_in;
			//regdatasel
			prif.MEM_RegWEN_out <= prif.EX_RegWEN_out;
			//result
			//overflow
			prif.MEM_RegDst_out <= prif.EX_RegDst_out;
			prif.MEM_halt_out <= prif.EX_halt_out;
		end
  	end
  end

endmodule // pipeline_registers