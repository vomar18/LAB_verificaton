interface moore_intf(input clk,rst);
  
  // INPUT  
  logic[2:0] coin_in; // input coin of my Vendi Mac {0=no coin,1=10c,2=20c,3=50c,4=1E,5=2E}
  logic[1:0] button_in; // input beverage of my Vendig Mac {0=no selected,1=water,2=soda}

  // OUTPUT
  logic[1:0] change_out;    // 0 = no change out, 1=10c, 2=20c
  logic[1:0] beverage_out;  // 0 = no beverage selected, 1=water, 2=soda

  modport dut (input clk, rst, coin_in, button_in, output change_out, beverage_out); // connection of DUT to interface
    
endinterface
