class transaction;
  //declaring the transaction items
  rand logic[2:0] coin_in; // input coin of my Vendi Mac {0=no coin,1=10c,2=20c,3=50c,4=1E,5=2E}
  rand logic[1:0] button_in; // input beverage of my Vendig Mac {0=no selected,1=water,2=soda}

  // constrain for each transaction
  constraint coin_input { coin_in inside {[0:7]}; }; 
  constraint button_input { button_in inside {[0:3]}; }; 

  //post-randomize function, displaying randomized values of items 
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    $display("values created:");
    $display("\t input coin = %0h",coin_in);
    $display("\t button selected = %0h",button_in);
    $display("-----------------------------------------");
  endfunction
  
  //deep copy method
  function transaction do_copy();
    transaction trans;
    trans = new();
    trans.coin_in  = this.coin_in;
    trans.button_in  = this.button_in;
    return trans;
  endfunction
endclass
