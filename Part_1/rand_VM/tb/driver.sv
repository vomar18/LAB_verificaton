//gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

class driver;

    //used to count the number of transactions
    int no_transactions;

    //creating virtual interface handle
    virtual moore_intf moore_vif;

    //creating mailbox handle
    mailbox gen2driv;

    //constructor
    function new(virtual moore_intf moore_vif,mailbox gen2driv);
        //getting the interface
        this.moore_vif = moore_vif;
        //getting the mailbox handles from  environment 
        this.gen2driv = gen2driv;
    endfunction

    //Reset task, Reset the Interface signals to default/initial values
    task reset;
        wait(moore_vif.rst);
        $display("--------- [DRIVER] Reset Started ---------");
        wait(!moore_vif.rst);
        $display("--------- [DRIVER] Reset Ended ---------");
    endtask

    //drivers the transaction items to interface signals
    task drive;
        transaction trans;
        gen2driv.get(trans);
        moore_vif.coin_in = trans.coin_in; 
        moore_vif.button_in = trans.button_in;    
//        if (trans.in>0 && trans.dec) begin
//        @(posedge counter_vif.clk);
//            counter_vif.start=0;
//            counter_vif.in=0;
//            wait(counter_vif.stop);
//        end
        no_transactions++;
        @(posedge moore_vif.clk);
    endtask


    task main;
        wait(!moore_vif.rst);
        forever
            drive();
   endtask

endclass
