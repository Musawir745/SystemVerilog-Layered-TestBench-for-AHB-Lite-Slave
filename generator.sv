class generator;
   transaction trans,tr;
  mailbox gen2driv;
  event ended;
  int  repeat_count;
  
  function new(mailbox gen2driv);
    this.gen2driv = gen2driv;
  endfunction
  
  task main();
    repeat(repeat_count) begin
       trans = new();
      trans.hwrite = 1'b1;
    if(!trans.randomize())
      $error("Generator trans randomization failed");
      gen2driv.put(trans);
      trans.display("[ Generator writting ]"); 
      tr = new trans;
      tr.hwrite=1'b0;
      gen2driv.put(tr);
      tr.display("[ Generator Reading ]"); 
    end
    -> ended;
  endtask
  endclass
