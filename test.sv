`include "environment.sv"
program test(mem_intf intf);
  environment env;
  
  initial
    begin
      env = new(intf);
      env.gen.repeat_count = 8;
      env.drv.repeat_count = 8;
      env.mon.repeat_count = 8;
      env.scb.repeat_count = 8;
      env.run();
    end
endprogram
