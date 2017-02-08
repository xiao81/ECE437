`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

module control_unit (
  control_unit_if.cu cuif
);

import cpu_types_pkg::*;

always_comb begin
  cuif.rs = 0;
  cuif.rt = 0;
  cuif.rd = 0;
  cuif.aluop = ALU_SLL;
  cuif.imm = 0;
  cuif.shamt = 0;
  cuif.MemToReg = 0;
  cuif.RegWEN = 0;
  cuif.dWEN = 0;
  cuif.dREN = 0;
  cuif.halt = 0;
  cuif.RegDst = 0;// 00: rd, 01: rt, 10: 31 
  cuif.PCSrc = 0; // 000: noJump, 001: J, 010: JAL, 011: JR, 100: Branch
  cuif.ALUSrc = 0; // 000: reg , 001: signExt , 010: zeroExt, 011: shamt, 100: LUI

  //R type
  if (cuif.instruction[31:26] == RTYPE) begin
  	cuif.rs = cuif.instruction[25:21];
  	cuif.rt = cuif.instruction[20:16];
  	cuif.rd = cuif.instruction[15:11];
  	cuif.shamt = {'0, cuif.instruction[10:6]};
  	case (cuif.instruction[5:0])
  		ADDU: begin
  			cuif.aluop = ALU_ADD;
  			cuif.RegWEN = 1;
  		end
  		ADD: begin
  			cuif.aluop = ALU_ADD;
  			cuif.RegWEN = 1;
  		end
  		AND: begin
  			cuif.aluop = ALU_AND;
  			cuif.RegWEN = 1;
  		end
  		JR: begin
  			cuif.PCSrc = 3'b011;
  		end
  		NOR: begin
  			cuif.aluop = ALU_NOR;
  			cuif.RegWEN = 1;
  		end
  		OR: begin
  			cuif.aluop = ALU_OR;
  			cuif.RegWEN = 1;
  		end
  		SLT: begin
  			cuif.aluop = ALU_SLT;
  			cuif.RegWEN = 1;
  		end
  		SLTU: begin
  			cuif.aluop = ALU_SLTU;
  			cuif.RegWEN = 1;
  		end
  	  SLL: begin
  	  	cuif.aluop = ALU_SLL;
  	  	cuif.ALUSrc = 3'b011;
  	  	cuif.RegWEN = 1;
  	  end
  	  SRL: begin
  	  	cuif.aluop = ALU_SRL;
  	  	cuif.ALUSrc = 3'b011;
  	  	cuif.RegWEN = 1;
  	  end
  	  SUBU: begin
  	  	cuif.aluop = ALU_SUB;
  	  	cuif.RegWEN = 1;
  	  end
  	  SUB: begin
  	  	cuif.aluop = ALU_SUB;
  	  	cuif.RegWEN = 1;
  	  end
  	  XOR: begin
  	  	cuif.aluop = ALU_XOR;
  	  	cuif.RegWEN = 1;
  	  end
  	endcase
  //J type
  end else if (cuif.instruction[31:26] == J) begin
  	cuif.PCSrc = 3'b001;
  end else if (cuif.instruction[31:26] == JAL) begin
  	cuif.PCSrc = 3'b010;
  	cuif.RegDst = 2'b10;
  	cuif.RegWEN =1;
  end else begin
  //I type
  	cuif.rs = cuif.instruction[25:21];
  	cuif.rt = cuif.instruction[20:16];
  	cuif.imm = cuif.instruction[15:0];
  	cuif.RegDst = 2'b01;
  	case (cuif.instruction[31:26])
  		ADDIU: begin
  			cuif.aluop = ALU_ADD;
  			cuif.ALUSrc = 3'b001; 
  			cuif.RegWEN = 1;
  		end
  		ADDI: begin
  			cuif.aluop = ALU_ADD;
  			cuif.ALUSrc = 3'b001; 
  			cuif.RegWEN = 1;
  		end
  		ANDI: begin
  			cuif.aluop = ALU_AND;
  			cuif.ALUSrc = 3'b010; 
  			cuif.RegWEN = 1;
  		end
  		BEQ: begin
  			cuif.aluop = ALU_SUB;
  			cuif.PCSrc = 3'b100; 
  		end
  		BNE: begin
  			cuif.aluop = ALU_SUB;
  			cuif.PCSrc = 3'b100; 
  		end
  		LUI: begin
  			cuif.ALUSrc = 3'b100;
  			cuif.RegWEN = 1;
  		end
  		LW: begin
  			cuif.MemToReg = 1;
  			cuif.RegWEN = 1;
  			cuif.aluop = ALU_ADD;
  			cuif.ALUSrc = 3'b001;
  			cuif.dREN =1;
  		end
  		ORI: begin
  			cuif.RegWEN = 1;
  			cuif.aluop = ALU_OR;
  			cuif.ALUSrc = 3'b010;
  		end
  		SLTI: begin
  			cuif.RegWEN = 1;
  			cuif.aluop = ALU_SLT;
  			cuif.ALUSrc = 3'b001;
  		end
  		SLTIU: begin
  			cuif.RegWEN = 1;
  			cuif.aluop = ALU_SLTU;
  			cuif.ALUSrc = 3'b001;
  		end
  		SW: begin
  			cuif.aluop = ALU_ADD;
  			cuif.ALUSrc = 3'b001;
        cuif.MemToReg = 0;
  			cuif.dWEN =1;
  		end
  		XORI: begin
  			cuif.RegWEN = 1;
  			cuif.aluop = ALU_XOR;
  			cuif.ALUSrc = 3'b010;
  		end
  		HALT: begin
  			cuif.halt = 1;
  		end
  	endcase
  end
end

endmodule