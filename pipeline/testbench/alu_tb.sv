`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if aluif ();
  // test program
  test PROG (CLK, aluif);
  // DUT
`ifndef MAPPED
  alu DUT(aluif);
`else
  alu DUT(
    .\aluif.port_a (aluif.port_a),
    .\aluif.port_b (aluif.port_b),
    .\aluif.port_out (aluif.port_out),
    .\aluif.aluop (aluif.aluop),
    .\aluif.negative (aluif.negative),
    .\aluif.zero (aluif.zero),
    .\aluif.overflow (aluif.overflow)
  );
`endif

endmodule

program test(
  input logic CLK,
  alu_if.tb tbif
);

  initial begin

    //SLL
    tbif.aluop = ALU_SLL;
    tbif.port_a = 32'h00000001;
    tbif.port_b = 32'h00000001;
    @(posedge CLK);
    if(tbif.port_out == tbif.port_a<<tbif.port_b) begin
      $display("ALU_SLL PASS");
    end
    else $display("ALU_SLL FAILED");
    //SLL
    tbif.aluop = ALU_SRL;
    tbif.port_a = 32'h00f00101;
    tbif.port_b = 32'h00003001;
    @(posedge CLK);
    if(tbif.port_out == tbif.port_a<<tbif.port_b) begin
      $display("ALU_SRL PASS");
    end
    else $display("ALU_SRL FAILED");
    //ADD + +
    tbif.aluop = ALU_ADD;
    tbif.port_a = 32'h010b0201;
    tbif.port_b = 32'h00301001;
    @(posedge CLK);
    if(tbif.port_out == $signed(tbif.port_a) + $signed(tbif.port_b)) begin
      $display("ALU_ADD ++ PASS");
    end
    else $display("ALU_ADD ++ FAILED");
    //ADD + -
    tbif.aluop = ALU_ADD;
    tbif.port_a = 32'h010b0201;
    tbif.port_b = 32'h10301001;
    @(posedge CLK);
    if(tbif.port_out == $signed(tbif.port_a) + $signed(tbif.port_b)) begin
      $display("ALU_ADD +- PASS");
    end
     else $display("ALU_ADD +- FAILED");
    //ADD - -
    tbif.aluop = ALU_ADD;
    tbif.port_a = 32'h110b0201;
    tbif.port_b = 32'h10301001;
    @(posedge CLK);
    if(tbif.port_out == $signed(tbif.port_a) + $signed(tbif.port_b)) begin
      $display("ALU_ADD -- PASS");
    end
     else $display("ALU_ADD -- FAILED");

    //SUB + +
    tbif.aluop = ALU_SUB;
    tbif.port_a = 32'h010b0201;
    tbif.port_b = 32'h00301001;
    @(posedge CLK);
    if(tbif.port_out == $signed(tbif.port_a) - $signed(tbif.port_b)) begin
      $display("ALU_SUB ++ PASS");
    end
    else $display("ALU_SUB ++ FAILED");
    //SUB + -
    tbif.aluop = ALU_SUB;
    tbif.port_a = 32'h010b0201;
    tbif.port_b = 32'h10301001;
    @(posedge CLK);
    if(tbif.port_out == $signed(tbif.port_a) - $signed(tbif.port_b)) begin
      $display("ALU_SUB +- PASS");
    end
    else $display("ALU_SUB +- FAILED");
    //SUB - -
    tbif.aluop = ALU_SUB;
    tbif.port_a = 32'h110b0201;
    tbif.port_b = 32'h10301001;
    @(posedge CLK);
    if(tbif.port_out == $signed(tbif.port_a) - $signed(tbif.port_b)) begin
      $display("ALU_SUB -- PASS");
    end
    else $display("ALU_SUB -- FAILED");
    //AND
    tbif.aluop = ALU_AND;
    tbif.port_a = 32'h0af04121;
    tbif.port_b = 32'h01203041;
    @(posedge CLK);
    if(tbif.port_out == (tbif.port_a & tbif.port_b)) begin
      $display("ALU_AND PASS");
    end
    else $display("ALU_AND FAILED");
     //OR
    tbif.aluop = ALU_OR;
    tbif.port_a = 32'h0af04121;
    tbif.port_b = 32'h01203041;
    @(posedge CLK);
    if(tbif.port_out == (tbif.port_a | tbif.port_b)) begin
      $display("ALU_OR PASS");
    end
    else $display("ALU_OR FAILED");
     //XOR
    tbif.aluop = ALU_XOR;
    tbif.port_a = 32'h0af04121;
    tbif.port_b = 32'h01203041;
    @(posedge CLK);
    if(tbif.port_out == (tbif.port_a ^ tbif.port_b)) begin
      $display("ALU_XOR PASS");
    end
    else $display("ALU_XOR FAILED");
     //SLT
    tbif.aluop = ALU_SLT;
    tbif.port_a = 32'h1af04121;
    tbif.port_b = 32'h01203041;
    @(posedge CLK);
    if(tbif.port_out == ($signed(tbif.port_a) < $signed(tbif.port_b))) begin
      $display("ALU_SLT PASS");
    end
    else $display("ALU_SLT FAILED");
    //SLTU
    tbif.aluop = ALU_SLT;
    tbif.port_a = 32'h1af04121;
    tbif.port_b = 32'h01203041;
    @(posedge CLK);
    if(tbif.port_out == (tbif.port_a < tbif.port_b)) begin
      $display("ALU_SLTU PASS");
    end
    else $display("ALU_SLTU FAILED");
    //ZERO
    tbif.aluop = ALU_SUB;
    tbif.port_a = 32'hffffffff;
    tbif.port_b = 32'hffffffff;
    @(posedge CLK);
    if(tbif.zero == 1) begin
      $display("ZERO FLAG PASS");
    end
    else $display("ZERO FLAG FAILED");

    //NEGATIVE
    tbif.aluop = ALU_SUB;
    tbif.port_a = 32'h00000000;
    tbif.port_b = 32'h0fffffff;
    @(posedge CLK);
    if(tbif.negative == 1) begin
      $display("NEGATIVE FLAG PASS");
    end
    else $display("NEGATIVE FLAG FAILED");

    //OVERFLOW ++
    tbif.aluop = ALU_ADD;
    tbif.port_a = 32'h7fffffff;
    tbif.port_b = 32'h7fffffff;
    @(posedge CLK);
    if(tbif.overflow == 1) begin
      $display("OVERFLOW FLAG PASS");
    end
    else $display("OVERFLOW FLAG FAILED");
    //OVERFLOW --
    tbif.aluop = ALU_ADD;
    tbif.port_a = 32'h8fffffff;
    tbif.port_b = 32'h8fffffff;
    @(posedge CLK);
    if(tbif.overflow == 1) begin
      $display("OVERFLOW FLAG PASS");
    end
    else $display("OVERFLOW FLAG FAILED");
    $finish;
  end
endprogram
