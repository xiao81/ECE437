/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"
`include "request_unit_if.vh"
`include "program_counter_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "pipeline_registers_if.vh"

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
  request_unit_if ruif();
  program_counter_if pcif();
  register_file_if rfif();
  alu_if aluif();
  pipeline_registers_if prif();

  //Mapping actual ports
  control_unit CU(cuif);
  request_unit RU(CLK, nRST, ruif);
  program_counter PC(CLK, nRST, pcif);
  register_file RF(CLK, nRST, rfif);
  alu ALU(aluif);
  pipeline_registers PR(CLK, nRST, dpif.ihit, dpif.dhit, prif);

  word_t SignExtImm, ZeroExtImm, JumpAddr, BranchAddr;
  
  always_comb begin
    SignExtImm = 0;
    BranchAddr = 0;
    rfif.WEN = 0;
    rfif.wsel = 0;
    rfif.wdat = 0;
    aluif.port_b = 0;
    pcif.new_pc = 0;

    //Extender ALUSrc
    if (prif.ID_imm_out[15] == 1) begin
      SignExtImm = {16'hffff, prif.ID_imm_out};
    end else begin
      SignExtImm = {16'h0000, prif.ID_imm_out};
    end
    //Extender PCSrc 
    if (prif.ID_instruction_out[31:26] == BEQ) begin
      if(prif.EX_zero_out == 1) begin
        BranchAddr = prif.ID_pc_add4_out + {ZeroExtImm[29:0], 2'b00};
      end else begin
        BranchAddr = prif.ID_pc_add4_out;
      end
    end 
    if (prif.ID_instruction_out[31:26] == BNE) begin
      if(prif.EX_zero_out == 0) begin
        BranchAddr = prif.ID_pc_add4_out + {ZeroExtImm[29:0], 2'b00};
      end else begin
        BranchAddr = prif.ID_pc_add4_out;
      end
    end
    //Register file
    //RegWEN
    if (prif.MEM_RegWEN_out && (dpif.ihit | dpif.dhit)) begin
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
    if(prif.ID_ALUSrc_out == 3'b100) begin 
      rfif.wdat = {prif.ID_imm_out, 16'h0000}; //LUI
    end else if (prif.ID_instruction_out[31:26] == JAL) begin
      rfif.wdat = prif.MEM_pc_add4_out;
    end else if (prif.MEM_MemToReg_out) begin
      rfif.wdat = prif.MEM_dmemload_out;
    end else begin
      rfif.wdat = prif.EX_port_out_out;
    end

    //ALU

    if (prif.ID_ALUSrc_out == 3'b000) begin
      aluif.port_b = prif.ID_rdat2_out;
    end else if (prif.ID_ALUSrc_out == 3'b001) begin
      aluif.port_b = SignExtImm;
    end else if (prif.ID_ALUSrc_out == 3'b010) begin
      aluif.port_b = ZeroExtImm;
    end else if (prif.ID_ALUSrc_out == 3'b011) begin
      aluif.port_b = prif.ID_shamt_out;
    end
  
    //PC    
    if (prif.EX_PCSrc_out == 3'b000) begin
      pcif.new_pc = prif.IF_pc_add4_out;
    end else if (cuif.PCSrc == 3'b001) begin
      pcif.new_pc = JumpAddr;
    end else if (cuif.PCSrc == 3'b010) begin
      pcif.new_pc = JumpAddr;
    end else if (cuif.PCSrc == 3'b011) begin
      pcif.new_pc = prif.ID_rdat1_out;
    end else if (cuif.PCSrc == 3'b100) begin
      pcif.new_pc = BranchAddr;
    end 
    
end

//Instruction
assign prif.IF_instruction_in = dpif.imemload;
//Zero and Jump
assign ZeroExtImm = {16'h0000, prif.ID_imm_in};
assign JumpAddr = {prif.ID_pc_add4_out[31:28], prif.ID_instruction_out[25:0],2'b00};
//Reg Selection
assign rfif.rsel1 = cuif.rs;
assign rfif.rsel2 = cuif.rt;
//PCEN
assign pcif.PCEN = dpif.ihit;
//ALU
assign aluif.port_a = prif.ID_rdat1_out;
assign aluif.aluop = prif.ID_aluop_out;
//Memory
assign dpif.imemREN = 1;
assign dpif.imemaddr = pcif.pc;
assign dpif.dmemREN = prif.EX_dREN_out;
assign dpif.dmemWEN = prif.EX_dWEN_out;
assign dpif.dmemstore = prif.EX_rdat2_out;
assign dpif.dmemaddr = prif.EX_port_out_out;
//halt
always_ff @(posedge CLK or negedge nRST) begin
   if(~nRST) begin
      dpif.halt<= 0;
   end else begin
      dpif.halt <= prif.MEM_halt_out;
   end
 end 


endmodule
