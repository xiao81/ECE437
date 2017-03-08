`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif0 ();
  caches_if cif1 ();
  cache_control_if ccif (cif0, cif1);
  cpu_ram_if ramif ();
  // test program
  test PROG (CLK, nRST, ccif, ramif);
  // DUT
  memory_control DUT(CLK, nRST, ccif);
  ram DUTT(CLK,nRST,ramif);




assign ramif.ramaddr = ccif.ramaddr;
assign ramif.ramstore = ccif.ramstore;
assign ramif.ramREN = ccif.ramREN;
assign ramif.ramWEN = ccif.ramWEN;
assign ccif.ramstate = ramif.ramstate;
assign ccif.ramload = ramif.ramload;

endmodule

program test(
  input logic CLK,
  output logic nRST,
  cache_control_if ccif,
  cpu_ram_if ramif
);
  parameter PERIOD = 10;
  initial begin
  	nRST = 0;
    #(PERIOD);
    #(PERIOD);
    nRST = 1;
    cif0.dstore = 32'b0;
    cif0.daddr = 32'b0;
    cif0.iaddr = 32'b0;
    cif0.iREN = 0;
    cif0.dREN = 0;
    cif0.dWEN = 0;
    #(PERIOD);
    #(PERIOD);

    //Load instruction
    cif0.iREN = 1;
    cif0.dREN = 0;
    cif0.dWEN = 0;
    cif0.dstore = 32'b0;
    cif0.daddr = 32'b0;
    cif0.iaddr = 32'b0;
    for (int i = 0; i < 32; i++) begin
        cif0.iaddr = cif0.iaddr + 4;
        #(PERIOD);
    	if(cif0.iload != ccif.ramload) begin
    		$display("Failded to read instruction %h at addr %h", ccif.ramload, ccif.ramaddr);
    	end

    end
    $display("PASS read instruction");

    //Write data
    cif0.iREN = 0;
    cif0.dREN = 0;
    cif0.dWEN = 1;
    cif0.dstore = 32'h88888888;
    cif0.daddr = 32'h0;
    cif0.iaddr = 32'b0;
    for (int i = 0; i < 32; i++) begin
      #(PERIOD);
      #(PERIOD);
    	if(cif0.dstore != ccif.ramstore) begin
    		$display("Failded to write data %h at addr %h", ccif.ramstore, cif0.daddr);
    	end
    	cif0.dstore = cif0.dstore + 10;
    	cif0.daddr += 1;
    end
    $display("PASS write data");
    //Read data
    cif0.iREN = 0;
    cif0.dREN = 1;
    cif0.dWEN = 0;
    cif0.daddr = 32'h000000F0;
    for (int i = 0; i < 32; i++) begin
      #(PERIOD);
    	if(cif0.dload != ccif.ramload) begin
    		$display("Failded to load data %h at addr %h", ccif.ramload, cif0.daddr);
    	end
    	cif0.daddr += 8;
    end
    $display("PASS load data");

    //Read instruction and  data same time
    cif0.iREN = 1;
    cif0.dREN = 1;
    cif0.dWEN = 0;
    cif0.daddr = 32'h000000F0;
    for (int i = 0; i < 32; i++) begin
      #(PERIOD);
      if(cif0.dload != ccif.ramload) begin
        $display("Failded to load data %h at addr %h", ccif.ramload, cif0.daddr);
      end
      cif0.daddr += 8;
    end
    $display("PASS load instruction and  data");
    dump_memory();
    $finish;
  end

    //Dump memory
  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    cif0.dREN = 0;
    cif0.dWEN = 0;
    cif0.daddr = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

endprogram
