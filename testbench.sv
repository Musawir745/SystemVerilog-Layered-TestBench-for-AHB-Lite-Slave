`include "interface.sv"
`include "test.sv"
module tbench_top;
 
  bit hclk;
  bit hresetn;
  
  always #5 hclk = ~hclk;
  
  initial begin
      hresetn = 0;
   #5;
    hresetn =1;
  end
  
  mem_intf intf(hclk,hresetn);
  
  test t1(intf);
  
  amba_ahb_slave DUT(
    .hclk(intf.hclk),
    .hresetn(intf.hresetn),
    .hsel(1'b1),
    .haddr(intf.haddr),
    .htrans(intf.htrans),
    .hwrite(intf.hwrite),
    .hsize(intf.hsize),
    .hburst(intf.hburst),
    .hprot(intf.hprot),
    .hwdata(intf.hwdata),
    .hrdata(intf.hrdata),
    .hready(intf.hready),
    .hresp(intf.hresp),
    .error(intf.error));
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
    #300;
  end
endmodule
