class scoreboard;
  mailbox mon2scb;
  int no_transactions;
  int repeat_count;
  event scb_ended;
  bit [7:0] mem [0:1023];
  
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
  task main();
   repeat(repeat_count*2) begin
      transaction trans;
      trans = new();
      mon2scb.get(trans);
      //$display("--------- [Scoreboard: %0d] ---------",no_transactions);
      if(trans.hwrite==0) begin
        if(mem[trans.haddr] != trans.hrdata)
          $error("[SCB-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.haddr,mem[trans.haddr],trans.hrdata);
        else 
          $display("[SCB-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.haddr,mem[trans.haddr],trans.hrdata);
      end
      else if(trans.hwrite==1)
        mem[trans.haddr] = trans.hwdata;
      no_transactions++;
    end
    -> scb_ended;
  endtask
endclass
