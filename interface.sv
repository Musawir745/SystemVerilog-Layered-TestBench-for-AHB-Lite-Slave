`include "amba_ahb_defines.v"

interface mem_intf #(AW=`AW, DW=`DW, RW=`RW)(input logic hclk, hresetn);
  // AMBA AHB decoder signal
  logic 		 hsel;
  // AMBA AHB master signals
  logic [AW-1:0] haddr;
  logic    [1:0] htrans;
  logic          hwrite;
  logic    [2:0] hsize;
  logic    [2:0] hburst;
  logic    [3:0] hprot;
  logic [DW-1:0] hwdata;
  // AMBA AHB slave signals
  logic [DW-1:0] hrdata;
  logic          hready;
  logic [RW-1:0] hresp; 
  // slave control signal
  logic 		 error;
  
  //driver clocking block
  clocking driver_cb @(posedge hclk);
    default input #0 output #0;
    output hsel;
    output haddr;
    output htrans;
    output hwrite;
    output hsize;
    output hburst;
    output hprot;
    output hwdata;
    input  hrdata;
	input  hready;
	input  hresp; 
	output error;
  endclocking
  
  //monitor clocking block
  clocking monitor_cb @(posedge hclk);
    default input #0;
    input hsel;
    input haddr;
    input htrans;
    input hwrite;
    input hsize;
    input hburst;
    input hprot;
    input hwdata;
    input hrdata;
	input hready;
	input hresp; 
	input error;
  endclocking
  
  //driver modport
  modport DRIVER  (clocking driver_cb,input hclk,hresetn);
  
  //monitor modport  
  modport MONITOR (clocking monitor_cb,input hclk,hresetn);
  
endinterface
