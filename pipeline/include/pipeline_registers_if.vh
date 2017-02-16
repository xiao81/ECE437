`ifndef PIPELINE_REGISTERS_IF_VH
`define PIPELINE_REGISTERS_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pipeline_registers_if;
  // import types
  import cpu_types_pkg::*;

  //IF input
  logic [31:0] IF_instruction_in;
  logic [31:0] IF_pc_add4_in; 
  //IF output
  logic [31:0] IF_instruction_out;
  logic [31:0] IF_pc_add4_out;

  //ID input
  logic [2:0] ID_ALUSrc_in;
  logic [1:0] ID_RegDst_in;
  logic ID_RegWEN_in;
  aluop_t ID_aluop_in;
  logic [1:0] ID_regWsel_in;
  logic [2:0] ID_PCSrc_in;
  logic ID_dWEN_in;
  logic ID_halt_in;
  logic [31:0] ID_rdat1_in;
  logic [31:0] ID_rdat2_in;

  logic ID_MemToReg_in;
  logic ID_dREN_in;
  logic [IMM_W-1:0]   ID_imm_in;
  logic [SHAM_W-1:0]  ID_shamt_in;
  regbits_t ID_rs_in;
  regbits_t ID_rt_in;
  regbits_t ID_rd_in;

  //ID output
  logic [31:0] ID_instruction_out;
  logic [31:0] ID_pc_add4_out;
  logic [1:0] ID_RegDst_out;
  logic ID_RegWEN_out;
  aluop_t ID_aluop_out;
  logic [2:0] ID_ALUSrc_out;
  logic [1:0] ID_regWsel_out;
  logic [2:0] ID_PCSrc_out;
  logic ID_dWEN_out;
  logic ID_halt_out;
  logic [31:0] ID_rdat1_out;
  logic [31:0] ID_rdat2_out;

  logic ID_MemToReg_out;
  logic ID_dREN_out;
  logic [IMM_W-1:0]   ID_imm_out;
  logic [SHAM_W-1:0]  ID_shamt_out;
  regbits_t ID_rs_out;
  regbits_t ID_rt_out;
  regbits_t ID_rd_out;
  

  //EX input
  logic EX_zero_in;
  logic [31:0] EX_port_out_in;
  logic [31:0] EX_result_in;
  logic [31:0] EX_WriteData_in;
  //EX output
  logic [31:0] EX_WriteData_out;
  logic [31:0] EX_instruction_out;
  logic [2:0] EX_PCSrc_out;
  logic [31:0] EX_pc_add4_out;
  logic EX_dWEN_out;
  logic [31:0] EX_port_out_out;
  logic EX_RegWEN_out;
  logic [31:0] EX_rdat2_out;
  logic [31:0] EX_rdat1_out;
  logic [1:0] EX_regWsel_out;
  logic EX_halt_out;
  logic [31:0] EX_result_out;
  logic EX_zero_out;
  logic [1:0] EX_RegDst_out;

  logic EX_MemToReg_out;
  logic EX_dREN_out;
  logic [IMM_W-1:0]   EX_imm_out;
  logic [SHAM_W-1:0]  EX_shamt_out;
  regbits_t EX_rs_out;
  regbits_t EX_rt_out;
  regbits_t EX_rd_out;
  logic [2:0] EX_ALUSrc_out;

  //MEM input
  logic [31:0] MEM_dmemload_in;
  //MEM output
  logic [31:0] MEM_instruction_out;
  logic [2:0] MEM_PCSrc_out;
  logic [31:0] MEM_pc_add4_out;
  logic [31:0] MEM_dmemload_out;
  logic [1:0] MEM_regWsel_out;
  logic MEM_RegWEN_out;
  logic [31:0] MEM_result_out;
  logic MEM_halt_out;
  logic [1:0] MEM_RegDst_out;

  logic MEM_MemToReg_out;
  logic MEM_dWEN_out;
  logic MEM_dREN_out;
  logic [IMM_W-1:0]   MEM_imm_out;
  logic [SHAM_W-1:0]  MEM_shamt_out;
  regbits_t MEM_rs_out;
  regbits_t MEM_rt_out;
  regbits_t MEM_rd_out;
  logic [31:0] MEM_port_out_out;
  logic [2:0] MEM_ALUSrc_out;

  logic [31:0] MEM_dmemload_reg;
  logic [31:0] MEM_regWsel_reg;


  modport pr (
  	input IF_instruction_in, IF_pc_add4_in,  ID_RegWEN_in, ID_RegDst_in, ID_MemToReg_in, ID_PCSrc_in,
    ID_ALUSrc_in, ID_dWEN_in, ID_dREN_in, ID_halt_in, ID_aluop_in, ID_imm_in,
     ID_shamt_in, ID_rs_in, ID_rt_in, ID_rd_in, ID_rdat1_in, ID_rdat2_in, 
      EX_zero_in, EX_port_out_in, EX_WriteData_in, 
      MEM_dmemload_in, EX_ALUSrc_out,ID_regWsel_in, EX_result_in,
     output IF_instruction_out, IF_pc_add4_out, ID_instruction_out, ID_pc_add4_out, ID_RegWEN_out, ID_RegDst_out, 
     ID_MemToReg_out, ID_PCSrc_out, ID_ALUSrc_out, ID_dWEN_out, ID_dREN_out, 
     ID_halt_out, ID_aluop_out, ID_imm_out, ID_shamt_out, ID_rs_out, ID_rt_out, 
     ID_rd_out, ID_rdat1_out, ID_rdat2_out, EX_instruction_out, EX_pc_add4_out, EX_RegWEN_out, EX_RegDst_out, EX_MemToReg_out, 
     EX_PCSrc_out, EX_dWEN_out, EX_dREN_out, EX_halt_out, EX_imm_out, EX_shamt_out, 
     EX_rs_out, EX_rt_out, EX_rd_out, EX_rdat2_out, EX_zero_out, EX_port_out_out, 
     EX_WriteData_out, MEM_instruction_out, MEM_pc_add4_out, MEM_RegWEN_out, 
     MEM_RegDst_out, MEM_MemToReg_out, MEM_PCSrc_out, MEM_dWEN_out, MEM_dREN_out, 
     MEM_halt_out, MEM_imm_out, MEM_shamt_out, MEM_rs_out, MEM_rt_out, MEM_rd_out, MEM_dmemload_out, MEM_port_out_out,
     MEM_ALUSrc_out, EX_regWsel_out, EX_result_out, MEM_regWsel_out, MEM_result_out, ID_regWsel_out,
     MEM_dmemload_reg, MEM_regWsel_reg, EX_rdat1_out
     );

endinterface : pipeline_registers_if

`endif