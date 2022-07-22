`define MON_IF mem_vif.MONITOR.monitor_cb
class monitor;
  virtual mem_intf mem_vif;
  mailbox mon2scb;
  int repeat_count;
  int no_transactions;
  
  function new(virtual mem_intf mem_vif, mailbox mon2scb);
    this.mem_vif = mem_vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task main();
    forever begin
      transaction trans;
      trans = new();
      @(posedge mem_vif.MONITOR.hclk);
        trans.haddr = `MON_IF.haddr;
        trans.htrans= `MON_IF.htrans;
        trans.hwrite= `MON_IF.hwrite;
        trans.hsize = `MON_IF.hsize;
        trans.hburst= `MON_IF.hburst;
        trans.hprot = `MON_IF.hprot;
        trans.hwdata= `MON_IF.hwdata;
        trans.hready= `MON_IF.hready;
        trans.hresp=  `MON_IF.hresp;
        trans.hrdata= `MON_IF.hrdata;
      @(posedge mem_vif.MONITOR.hclk);
      no_transactions++;
      @(posedge mem_vif.MONITOR.hclk);
      mon2scb.put(trans);
      //trans.display("[ Monitor ]");
    end
  endtask
endclass
