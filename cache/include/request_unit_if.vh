`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic dWEN,dREN, dmemREN, dmemWEN, imemREN, dhit, ihit;

  modport ru (
	input dWEN,dREN, dhit, ihit,
	output dmemREN, dmemWEN, imemREN
  );
  modport tb (
	input dmemREN, dmemWEN, imemREN,
	output dREN, dWEN, dhit, ihit
  );

endinterface

`endif