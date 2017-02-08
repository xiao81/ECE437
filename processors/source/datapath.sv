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

  //Mapping actual ports
  control_unit CU(cuif);
  request_unit RU(CLK, nRST, ruif);
  program_counter PC(CLK, nRST, pcif);
  register_file RF(CLK, nRST, rfif);
  alu ALU(aluif);

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
    if (cuif.imm[15] == 1) begin
      SignExtImm = {16'hffff, cuif.imm};
    end else begin
      SignExtImm = {16'h0000, cuif.imm};
    end
    //Extender PCSrc 
    if (cuif.instruction[31:26] == BEQ) begin
      if(aluif.zero == 1) begin
        BranchAddr = pcif.npc + {ZeroExtImm[29:0], 2'b00};
      end else begin
        BranchAddr = pcif.npc;
      end
    end 
    if (cuif.instruction[31:26] == BNE) begin
      if(aluif.zero == 0) begin
        BranchAddr = pcif.npc + {ZeroExtImm[29:0], 2'b00};
      end else begin
        BranchAddr = pcif.npc;
      end
    end
    //Register file
    //RegWEN
    if (cuif.RegWEN && (dpif.ihit | dpif.dhit)) begin
      rfif.WEN = 1;
    end else begin
      rfif.WEN = 0;
    end
    //RegDst
    if(cuif.RegDst == 2'b00) begin
      rfif.wsel = cuif.rd;
    end else if (cuif.RegDst == 2'b01) begin
      rfif.wsel = cuif.rt;
    end else if (cuif.RegDst == 2'b10) begin
      rfif.wsel = 5'b11111;
    end
    //Reg write
    if(cuif.ALUSrc == 3'b100) begin 
      rfif.wdat = {cuif.imm, 16'h0000}; //LUI
    end else if (cuif.instruction[31:26] == JAL) begin
      rfif.wdat = pcif.npc;
    end else if (cuif.MemToReg) begin
      rfif.wdat = dpif.dmemload;
    end else begin
      rfif.wdat = aluif.port_out;
    end

    //ALU

    if (cuif.ALUSrc == 3'b000) begin
      aluif.port_b = rfif.rdat2;
    end else if (cuif.ALUSrc == 3'b001) begin
      aluif.port_b = SignExtImm;
    end else if (cuif.ALUSrc == 3'b010) begin
      aluif.port_b = ZeroExtImm;
    end else if (cuif.ALUSrc == 3'b011) begin
      aluif.port_b = cuif.shamt;
    end
  
    //PC    
    if (cuif.PCSrc == 3'b000) begin
      pcif.new_pc = pcif.npc;
    end else if (cuif.PCSrc == 3'b001) begin
      pcif.new_pc = JumpAddr;
    end else if (cuif.PCSrc == 3'b010) begin
      pcif.new_pc = JumpAddr;
    end else if (cuif.PCSrc == 3'b011) begin
      pcif.new_pc = rfif.rdat1;
    end else if (cuif.PCSrc == 3'b100) begin
      pcif.new_pc = BranchAddr;
    end 
    
end

//Instruction
assign cuif.instruction = dpif.imemload;
//Zero and Jump
assign ZeroExtImm = {16'h0000, cuif.imm};
assign JumpAddr = {pcif.npc[31:28], dpif.imemload[25:0],2'b00};
//Reg Selection
assign rfif.rsel1 = cuif.rs;
assign rfif.rsel2 = cuif.rt;
//PCEN
assign pcif.PCEN = dpif.ihit;
//ALU
assign aluif.port_a = rfif.rdat1;
assign aluif.aluop = cuif.aluop;
//Request Unit
assign ruif.dWEN = cuif.dWEN;
assign ruif.dREN = cuif.dREN;
assign ruif.dhit = dpif.dhit;
assign ruif.ihit = dpif.ihit;
//Memory
assign dpif.imemREN = ruif.imemREN;
assign dpif.imemaddr = pcif.pc;
assign dpif.dmemREN = ruif.dmemREN;
assign dpif.dmemWEN = ruif.dmemWEN;
assign dpif.dmemstore = rfif.rdat2;
assign dpif.dmemaddr = aluif.port_out;
//halt
always_ff @(posedge CLK or negedge nRST) begin
   if(~nRST) begin
      dpif.halt<= 0;
   end else begin
      dpif.halt <= cuif.halt;
   end
 end 


endmodule
