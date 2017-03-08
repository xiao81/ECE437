/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (CLK, nRST, rfif);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(
  input logic CLK,
  output logic nRST,
  register_file_if.tb tbif
);
  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;
  initial begin
    nRST = 0;
    @(posedge CLK);
    nRST = 1;
    tbif.WEN = 1;
    // small value on 1
    for (int i = 0; i < 32; i++) begin
     
      tbif.wsel = i;
      tbif.wdat = v1;
        @(posedge CLK);
      v1+=1;
    end
    tbif.WEN = 0;
     
    for (int i = 31; i >= 0; i--) begin  
      tbif.rsel1 = i;
       
      v1-=1;
      @(posedge CLK);
      if (tbif.rdat1 != v1 && i != 0) begin
        $display("Failed when read value: %d", v1);
      end
      else if (i == 0) begin
        if (tbif.rdat1 != 0) begin
        $display("0th location value is not zero");
        end
      end
    end
    $display("PASS store and read small value with 1");
    
    tbif.WEN = 1;
    @(posedge CLK);
    //large value on 2
    for (int i = 0; i < 32; i++) begin    
      tbif.wsel = i;
      tbif.wdat = v3;
      @(posedge CLK);
      v3-=100;
    end
    tbif.WEN = 0;

    for (int i = 31; i >= 0; i--) begin  
      tbif.rsel2 = i;
      v3+=100;
      @(posedge CLK);
      if (tbif.rdat2 != v3 && i != 0) begin
        $display("Failed when read value: %d", v3);
      end
      else if (i == 0) begin
        if (tbif.rdat2 != 0) begin
        $display("0th location value is not zero");
        end
      end
    end

    $display("PASS store and read large value with 2");
    //nRST
    nRST = 0;
    @(posedge CLK);
    for (int i = 0; i < 32; i++) begin
      tbif.rsel1 = i;
      tbif.rsel2 = i; 
      if (tbif.rdat2 != 0 ||tbif.rdat1 !=0) begin
        $display("%d location is not zero", i);
        end
    end
    $display("PASS nRST test");

    //WEN
    tbif.WEN = 0;
    for (int i = 0; i < 32; i++) begin
      tbif.wsel = i;
      tbif.wdat = i;
      @(posedge CLK);
    end
    for (int i = 0; i < 32; i++) begin
      tbif.rsel1 = i;
      tbif.rsel2 = i;
      @(posedge CLK);
      if (tbif.rdat2 != 0 ||tbif.rdat1 !=0) begin
        $display("%d location is not zero", i);
        end
    end
    $display("PASS WEN test");

    $finish;
  end
  
endprogram
