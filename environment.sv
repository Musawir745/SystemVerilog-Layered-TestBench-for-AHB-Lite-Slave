`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  generator gen;
  driver    drv;
  monitor   mon;
  scoreboard scb;
  
  mailbox gen2driv;
  mailbox mon2scb;
  
  virtual mem_intf mem_vif;
  
  function new(virtual mem_intf mem_vif);
     this.mem_vif = mem_vif;
    gen2driv = new();
    mon2scb  = new();
    gen  = new(gen2driv);
    drv  = new(mem_vif,gen2driv);
    mon  = new(mem_vif,mon2scb);
    scb  = new(mon2scb);
  endfunction
  
   task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    drv.main();
    mon.main();
    scb.main();      
    join_any
  endtask
  
  task post_test();
    wait(gen.ended.triggered);
    //$write("generator triggered");
   wait(drv.drv_ended.triggered);
   // $write("generator triggered");
     wait(scb.scb_ended.triggered);
//    wait(gen.repeat_count == drv.no_transactions);
  //  wait(gen.repeat_count == scb.no_transactions);
  endtask
  
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
endclass
