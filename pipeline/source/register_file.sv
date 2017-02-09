`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

module register_file (
  input logic CLK, nRST,
  register_file_if.rf rfif
);

import cpu_types_pkg::*;
word_t regs [31:0];

always_ff @(negedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    regs <= '{default:'0};
  end
  else if (rfif.wsel != 0) begin
    if(rfif.WEN) begin
      regs[rfif.wsel] <= rfif.wdat;
    end
  end
end

always_comb begin
  rfif.rdat1 = regs[rfif.rsel1];
  rfif.rdat2 = regs[rfif.rsel2];
end
endmodule
  


