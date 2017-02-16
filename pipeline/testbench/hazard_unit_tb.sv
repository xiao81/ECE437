`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  hazard_unit_if huif ();

  // test program
  test PROG (
    CLK,
    nRST,
    huif
  );
 
  // DUT
  //memory_control DUT(CLK,nRST,ccif);
  //ram DUT2(CLK,nRST,crif);
  hazard_unit DUT(huif);

endmodule

program test(
  input logic CLK,
  output logic nRST,
  hazard_unit_if.tb tbif
);

parameter PERIOD = 10;

initial begin
  //initial reset
  nRST = 0;
  #(PERIOD);
  #(PERIOD);
  nRST = 1;
  #(PERIOD);
  tbif.EX_instruction_out[31:26] = BEQ;
  tbif.EX_instruction_out[20:16] = 1;
  tbif.EX_instruction_out[15:11] = 0;
  #(PERIOD);
  if(tbif.EX_reg == 1 && tbif.EX_forward == 0 ) begin
    $display("BEQ PASS");
  end
  else begin 
    $display("BEQ FAILED");
  end

 
  #(PERIOD);
  tbif.EX_instruction_out[31:26] = RTYPE;
  tbif.EX_instruction_out[20:16] = 1;
  tbif.EX_instruction_out[15:11] = 0;
  #(PERIOD);
  if(tbif.EX_reg == 0 && tbif.EX_forward == 1) begin
    $display("RTYPE PASS");
  end
  else begin 
    $display("RTYPE FAILED");
  end
  
  #(PERIOD);
  tbif.EX_instruction_out[31:26] = BEQ;
  tbif.EX_instruction_out[20:16] = 1;
  tbif.EX_instruction_out[15:11] = 1;
  #(PERIOD);
  if(tbif.EX_reg == 1 && tbif.EX_forward == 0 ) begin
    $display("BEQ2 PASS");
  end
  else begin 
    $display("BEQ2 FAILED");
  end

  #(PERIOD);
  tbif.EX_instruction_out[31:26] = SW;
  tbif.EX_instruction_out[20:16] = 0;
  tbif.EX_instruction_out[15:11] = 0;
  #(PERIOD);
  if(tbif.EX_reg == 0 && tbif.EX_forward == 0) begin
    $display("SW PASS");
  end
  else begin 
    $display("SW FAILED");
  end

 #(PERIOD);
 #(PERIOD);
  $finish; 
end


endprogram
