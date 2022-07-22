`include "amba_ahb_defines.v"

class transaction #(AW=`AW, DW=`DW, RW=`RW);
  // AMBA AHB decoder signal
 // rand bit 		 hsel;
 // AMBA AHB master signals
  rand bit [AW-1:0] haddr;
  rand bit    [1:0] htrans;
       bit          hwrite;
  rand bit    [2:0] hsize;
  rand bit    [2:0] hburst;
  rand bit    [3:0] hprot;
  rand bit [DW-1:0] hwdata;
  // AMBA AHB slave signals
  bit [DW-1:0] hrdata;
  bit          hready;
  bit [RW-1:0] hresp; 
  // slave control signal
  bit 		 error;
  
  constraint c1 {hburst == 3'b000;}
  constraint c2 {htrans == 2'b10;}
  constraint c3 {if(hsize==3'b010) haddr %4 ==0;}
  constraint c4 {hprot == 4'b0001;}
  constraint c5 {hsize == 3'b010;}
  constraint c6 {haddr  inside {[0:255]};}
  constraint c7 {hwdata inside {[0:255]};}
  
  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("- haddr = %0h, htrans = %b, hwrite = %b, hsize = %b",haddr,htrans, hwrite, hsize);
    $display("- hburst = %b, hprot = %b, hwdata = %0h",hburst,hwrite,hwdata);
    $display("- hrdata = %0h, hready = %b, hresp = %b",hrdata,hready,hresp);
    $display("-------------------------");
  endfunction
  
endclass
