/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"
`include "program_counter_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "pipeline_registers_if.vh"
`include "hazard_unit_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  //interfaces
  control_unit_if cuif();
  program_counter_if pcif();
  register_file_if rfif();
  alu_if aluif();
  pipeline_registers_if prif();
  hazard_unit_if huif();

  //Mapping actual ports
  logic flush;
  control_unit CU(cuif);
  program_counter PC(CLK, nRST, pcif);
  register_file RF(CLK, nRST, rfif);
  alu ALU(aluif);
  hazard_unit HU(huif);
  pipeline_registers PR(CLK, nRST, dpif.ihit, dpif.dhit, flush, huif.lw_hazard, prif);

  word_t SignExtImm, ZeroExtImm, JumpAddr, BranchAddr, luiExtImm, shamt;
  word_t temp;

  always_comb begin
    SignExtImm = 0;
    BranchAddr = 0;
    rfif.WEN = 0;
    rfif.wsel = 0;
    pcif.new_pc = 0;

    //Extender ALUSrc
    if (prif.ID_instruction_out[15]) begin
      SignExtImm = {16'hffff, prif.ID_instruction_out[15:0]};
    end else begin
      SignExtImm = {16'h0000, prif.ID_instruction_out[15:0]};
    end
    //Extender PCSrc 
    if (prif.ID_instruction_out[31:26] == BEQ) begin
      if(prif.EX_zero_in == 1) begin
        BranchAddr = prif.ID_pc_add4_out + {ZeroExtImm[29:0], 2'b00};
      end else begin
        BranchAddr = prif.ID_pc_add4_out;
      end
    end 
    if (prif.ID_instruction_out[31:26] == BNE) begin
      if(prif.EX_zero_in == 0) begin
        BranchAddr = prif.ID_pc_add4_out + {ZeroExtImm[29:0], 2'b00};
      end else begin
        BranchAddr = prif.ID_pc_add4_out;
      end
    end
    //Register file
    //RegWEN
    if (prif.MEM_RegWEN_out) begin
      rfif.WEN = 1;
    end else begin
      rfif.WEN = 0;
    end
    //RegDst
    if(prif.MEM_RegDst_out == 2'b00) begin
      rfif.wsel = prif.MEM_rd_out;
    end else if (prif.MEM_RegDst_out == 2'b01) begin
      rfif.wsel = prif.MEM_rt_out;
    end else if (prif.MEM_RegDst_out == 2'b10) begin
      rfif.wsel = 5'b11111;
    end
    //Reg write
    /*
    if(prif.MEM_ALUSrc_out == 3'b100) begin 
      rfif.wdat = {prif.MEM_imm_out, 16'h0000}; //LUI
    end else if (prif.MEM_instruction_out[31:26] == JAL) begin
      rfif.wdat = prif.MEM_pc_add4_out;
    end else if (prif.MEM_MemToReg_out) begin
      rfif.wdat = prif.MEM_dmemload_out;
    end else begin
      rfif.wdat = prif.MEM_port_out_out;
    end */

    //ALU 
    if(prif.ID_instruction_out[31:26] != RTYPE) begin
      if(prif.ID_rs_out == huif.EX_reg) begin
        aluif.port_a = prif.EX_result_out;
      end
      else if(prif.ID_rs_out == huif.MEM_reg) begin
        aluif.port_a = (prif.MEM_regWsel_out == 2'b01) ? prif.MEM_dmemload_out : prif.MEM_result_out;
      end
      else begin
        aluif.port_a = prif.ID_rdat1_out;
      end
    end else begin
      if(prif.ID_rs_out == huif.EX_reg) begin
        aluif.port_a = prif.EX_result_out;
      end
      else if(prif.ID_rs_out == huif.MEM_reg) begin
        aluif.port_a = (prif.MEM_regWsel_out == 2'b01) ? prif.MEM_dmemload_out : prif.MEM_result_out;
      end
      else begin
        aluif.port_a = prif.ID_rdat1_out;
      end
      if(prif.ID_dWEN_out) begin
        temp = prif.ID_rdat2_out;
      end
      else if(prif.ID_rt_out ==huif.EX_reg) begin
        temp = prif.EX_result_out;
      end
      else if(prif.ID_rt_out == huif.MEM_reg) begin
        temp = (prif.MEM_regWsel_out == 2'b01) ? prif.MEM_dmemload_out : prif.MEM_result_out;
      end
      else begin
        temp = prif.ID_rdat2_out;
      end
    end
  
    //PC   
    flush = 0; 
    if (prif.EX_PCSrc_out == 3'b000) begin
      pcif.new_pc = pcif.npc;
    end else if (prif.EX_PCSrc_out == 3'b001) begin
      pcif.new_pc = JumpAddr;
      flush = 1;
    end else if (prif.EX_PCSrc_out == 3'b010) begin
      pcif.new_pc = JumpAddr;
      flush = 1;
    end else if (prif.EX_PCSrc_out == 3'b011) begin
      if(prif.EX_zero_out) begin
        pcif.new_pc = prif.ID_rdat1_out;
        flush = 1;
      end else begin
        pcif.new_pc = prif.ID_rdat1_out;
      end
    end else if (prif.EX_PCSrc_out == 3'b100) begin
      if(prif.EX_zero_out) begin
        pcif.new_pc = BranchAddr;
        flush = 1;
      end else begin
        pcif.new_pc = BranchAddr;
      end
    end 
    
end

assign rfif.wdat =  (prif.MEM_regWsel_out == 2'b01) ? prif.MEM_dmemload_out : prif.MEM_result_out;
//Instruction
//setup cuif
assign cuif.instruction = prif.IF_instruction_out;
//assign prif.IF_instruction_in = dpif.imemload;
//Zero and Jump
assign ZeroExtImm = {16'h0000, prif.ID_instruction_out[15:0]};
assign JumpAddr = {pcif.pc[31:28], prif.EX_instruction_out[25:0],2'b00};
assign shamt = {24'h000000, 3'b000, prif.ID_instruction_out[10:6]};
assign luiExtImm = {prif.ID_instruction_out[15:0], 16'h0000};
//Reg Selection
assign rfif.rsel1 = prif.IF_instruction_out[25:21];
assign rfif.rsel2 = prif.IF_instruction_out[20:16];
//PCEN
assign pcif.PCEN = flush ? (dpif.ihit|dpif.dhit) : dpif.ihit & (~dpif.dhit);
//ALU
//assign aluif.port_a = prif.ID_rdat1_out;
assign aluif.port_b = (prif.ID_ALUSrc_out== 3'b000) ? temp : ((prif.ID_ALUSrc_out== 3'b001) ? SignExtImm : ((prif.ID_ALUSrc_out== 3'b010) ? ZeroExtImm : shamt));
assign aluif.aluop = prif.ID_aluop_out;
//Memory
assign dpif.imemREN = 1;
assign dpif.imemaddr = pcif.pc;
assign dpif.dmemREN = (prif.EX_regWsel_out == 2'b01);
assign dpif.dmemWEN = prif.EX_dWEN_out;
assign dpif.dmemstore = prif.EX_WriteData_out;
assign dpif.dmemaddr = prif.EX_port_out_out;
//prif IF
assign prif.IF_instruction_in = (dpif.ihit) ? dpif.imemload : '0;
assign prif.IF_pc_add4_in = pcif.npc;
//prif ID
assign prif.ID_rdat1_in = rfif.rdat1;
assign prif.ID_rdat2_in = rfif.rdat2;
assign prif.ID_ALUSrc_in = cuif.ALUSrc;
assign prif.ID_regWsel_in = cuif.regWsel;
assign prif.ID_PCSrc_in = cuif.PCSrc;
assign prif.ID_dWEN_in = cuif.dWEN;
assign prif.ID_halt_in = cuif.halt;
assign prif.ID_aluop_in = cuif.aluop;
assign prif.ID_RegDst_in = cuif.RegDst;
assign prif.ID_RegWEN_in = cuif.RegWEN;
assign prif.ID_rs_in = prif.IF_instruction_out[25:21];
assign prif.ID_rt_in = prif.IF_instruction_out[20:16];
assign prif.ID_rd_in = prif.ID_instruction_out[15:11];

/*
assign prif.ID_MemToReg_in = cuif.MemToReg;
assign prif.ID_dREN_in = cuif.dREN;
assign prif.ID_imm_in = cuif.imm;
assign prif.ID_shamt_in = cuif.shamt;
assign prif.ID_rs_in = cuif.rs;
assign prif.ID_rt_in = cuif.rt;
assign prif.ID_rd_in = cuif.rd;
*/

//prif EX
assign prif.EX_result_in = (prif.ID_regWsel_out == 2'b00) ? aluif.port_out : ((prif.ID_regWsel_out == 2'b10) ? luiExtImm : prif.ID_pc_add4_out);
assign prif.EX_port_out_in = aluif.port_out;
assign prif.EX_zero_in = aluif.zero;
assign prif.EX_WriteData_in = (prif.ID_rt_out == huif.EX_reg) ? prif.EX_result_out : ((prif.ID_rt_out == huif.MEM_reg) ? ((prif.MEM_regWsel_out == 2'b01) ? prif.MEM_dmemload_out : prif.MEM_result_out) : prif.ID_rdat2_out);
//prif MEM
assign prif.MEM_dmemload_in = dpif.dmemload;
//halt
always_ff @(posedge CLK or negedge nRST) begin
   if(~nRST) begin
      dpif.halt<= 0;
   end else begin
      dpif.halt <= prif.MEM_halt_out;
   end
 end 


endmodule
