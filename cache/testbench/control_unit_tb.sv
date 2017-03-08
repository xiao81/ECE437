`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  control_unit_if tbif ();
  // test program
  test PROG (CLK, tbif);
  // DUT
  control_unit DUT(tbif);


endmodule

program test(
  input logic CLK,
  control_unit_if.tb tbif
);

  initial begin
  //R Type
  tbif.instruction[31:26] = RTYPE;
  tbif.instruction[25:21] = 5'b0001; 
  tbif.instruction[20:16] = 5'b0010; 
  tbif.instruction[15:11] = 5'b0011; 
  tbif.instruction[5:0] = ADD;
  @(posedge CLK);
    if(tbif.aluop == ALU_ADD && tbif.RegWEN == 1) begin
      $display("ADD PASS");
    end
    else $display("ADD FAILED"); 

  tbif.instruction[5:0] = JR;
  @(posedge CLK);
    if(tbif.PCSrc == 3'b011) begin
      $display("JR PASS");
    end
    else $display("JR FAILED");

   tbif.instruction[5:0] = SLL;
  @(posedge CLK);
    if(tbif.ALUSrc == 3'b011 && tbif.aluop == ALU_SLL && tbif.RegWEN == 1) begin
      $display("SLL PASS");
    end
    else $display("SLL FAILED");
    //J/JAL
  tbif.instruction[31:26] = J;
  @(posedge CLK);
    if(tbif.PCSrc == 3'b001) begin
      $display("J PASS");
    end
    else $display("J FAILED");
  tbif.instruction[31:26] = JAL;
  @(posedge CLK);
    if(tbif.PCSrc == 3'b010 && tbif.RegDst == 2'b10 && tbif.RegWEN == 1) begin
      $display("JAL PASS");
    end
    else $display("JAL FAILED");
  //I type
  tbif.instruction[31:26] = ADDI;
  @(posedge CLK);
    if(tbif.ALUSrc == 3'b001 && tbif.aluop == ALU_ADD && tbif.RegWEN == 1) begin
      $display("ADDI PASS");
    end
    else $display("ADDI FAILED");
  tbif.instruction[31:26] = BEQ;
  @(posedge CLK);
    if(tbif.PCSrc == 3'b100 && tbif.aluop == ALU_SUB ) begin
      $display("BEQ PASS");
    end
    else $display("BEQ FAILED");
  tbif.instruction[31:26] = LW;
  @(posedge CLK);
    if(tbif.ALUSrc == 3'b001 && tbif.aluop == ALU_ADD && tbif.RegWEN == 1 && tbif.dREN == 1 && tbif.MemToReg == 1) begin
      $display("LW PASS");
    end
    else $display("LW FAILED");
  tbif.instruction[31:26] = SW;
  @(posedge CLK);
    if(tbif.ALUSrc == 3'b001 && tbif.aluop == ALU_ADD && tbif.dWEN == 1 ) begin
      $display("SW PASS");
    end
    else $display("SW FAILED");
  tbif.instruction[31:26] = HALT;
  @(posedge CLK);
    if(tbif.halt == 1) begin
      $display("HALT PASS");
    end
    else $display("HALT FAILED");
  end
endprogram
