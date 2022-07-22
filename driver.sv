`define DRIV_IF mem_vif.DRIVER.driver_cb

class driver;
  virtual mem_intf mem_vif;
  mailbox gen2driv;
  int repeat_count;
  int no_transactions;
  event drv_ended;
  
  function new(virtual mem_intf mem_vif, mailbox gen2driv);
    this.mem_vif = mem_vif;
    this.gen2driv = gen2driv;
  endfunction
  
  task reset;
    wait(!mem_vif.hresetn);
    $display("--------- [DRIVER] Reset Started ---------");
    `DRIV_IF.haddr  <= 0;
    `DRIV_IF.htrans <= 0;
    `DRIV_IF.hwrite <= 0; 
    `DRIV_IF.hsize  <= 0;
    `DRIV_IF.hburst <= 0;
    `DRIV_IF.hprot  <= 0;
    `DRIV_IF.hwdata <= 0; 
    wait(mem_vif.hresetn);
    $display("--------- [DRIVER] Reset Ended ---------");
  endtask
  
  task drive;
     transaction trans; 
     trans=new();
     gen2driv.get(trans);
    // $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
    @(posedge mem_vif.DRIVER.hclk);
    `DRIV_IF.haddr  <= trans.haddr;
 	`DRIV_IF.hsize  <= trans.hsize;
 	`DRIV_IF.hburst <= trans.hburst;
 	`DRIV_IF.hprot  <= trans.hprot;
 	`DRIV_IF.htrans <= trans.htrans;
 	`DRIV_IF.hwrite <= trans.hwrite;
 	`DRIV_IF.hwdata <= trans.hwdata;
     @(posedge mem_vif.DRIVER.hclk);
     trans.hrdata = `DRIV_IF.hrdata;
     no_transactions++;
     @(posedge mem_vif.DRIVER.hclk);
     //trans.display("[ Driver ]");
    -> drv_ended;
  endtask
  
  task main();
    forever begin
      fork
        begin
        wait(mem_vif.hresetn);
        end
        begin
         forever
            drive();
          end
        join
    end
  endtask
        
  
endclass : driver
