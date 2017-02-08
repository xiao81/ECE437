/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;
  
  //iwait is 0 when dREN = 0 and dWEN = 0 and iREN is 1
  //assign ccif.iwait = (ccif.ramstate == ACCESS && ~(ccif.dREN || ccif.dWEN) && ccif.iREN) ? 0 : 1;
  //dwait is 0 when dREN = 1 or dWEN = 1
  //assign ccif.dwait = (ccif.ramstate == ACCESS && (ccif.dREN || ccif.dWEN)) ? 0 : 1;
  
  assign ccif.iload = ccif.ramload;
  assign ccif.dload = ccif.ramload;
  
  assign ccif.ramstore = ccif.dstore;
  //assign ccif.ramaddr = (ccif.dREN || ccif.dWEN) ? ccif.daddr : ccif.iaddr;
  assign ccif.ramWEN = ccif.dWEN;

  always_comb begin
    ccif.ramaddr = 0;
    ccif.ramREN =0;
    ccif.iwait =1;
    ccif.dwait =1;
    if((ccif.dREN || ccif.iREN) && ~(ccif.dWEN)) begin
      ccif.ramREN = 1;
    end else begin
      ccif.ramREN = 0;
    end
    if(ccif.ramstate == ACCESS) begin
        if(ccif.dREN || ccif.dWEN) begin
          ccif.iwait = 1;
          ccif.dwait = 0;
        end
        else if(ccif.iREN) begin
          ccif.iwait = 0;
          ccif.dwait = 1;
        end
    end
    if(ccif.dWEN || ccif.dREN)
    begin
      ccif.ramaddr = ccif.daddr;
    end
    else
    begin
      ccif.ramaddr = ccif.iaddr;
    end
  end

endmodule
