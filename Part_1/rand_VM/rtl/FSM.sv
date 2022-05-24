

// now the DUT use the interface
// dut (input clk, rst, coin_in, button_in, output change_out, beverage_out); // connection of DUT to interface
// e nell'interface gli passo intf.dut


module moore (moore_intf intf);

    // State encodings, there are 6 status --> 3 bits
    typedef enum reg[2:0] {INIT=0, START, WATER, SODA, CALC_CHANGE, RETURN_CHANGE} State;

    State state;            // state register
    reg[5:0] balance=0;     // balance register, save the tens of cents -> max 60 x 10 cent = 6 EURO
    reg[9:0] T_clk_cycle=0;  // clock cycle status, save the number of clock cycle done by the VM

    // the output register --> then assign to output wire
    logic[1:0] change = 0;  
    logic[1:0] beverage = 0;

    parameter MAX_COIN = 60;
    // simulate the time for delivering a beverage (N) and select and return the correct change (M)
    parameter N = 5; // time for delivering a beverage
    parameter M = 1+N+5; // time for give back the change only after delivering a beverage

    always_ff @(posedge intf.clk or intf.rst) begin
        if(intf.rst)begin
            state <= INIT;
        end else begin
            case (state)
                INIT:
                begin
                    T_clk_cycle <= 10'b0000000000;
                    balance <= 5'b00000;
                    state <= START;
                end
                START: // DEVI SEGNALARE CHE SE SONO INSERITI DEI SOLDI
                    if (intf.coin_in==1) begin
                        if ((balance + 1) <= MAX_COIN) begin
                            balance <= balance + 1;
                        end else begin
                            balance <= MAX_COIN;
                        end
                    end else if (intf.coin_in==2) begin
                        if ((balance + 2) <= MAX_COIN) begin
                            balance <= balance + 2;
                        end else begin
                            balance <= MAX_COIN;
                        end
                    end else if (intf.coin_in==3) begin
                        if ((balance + 5) <= MAX_COIN) begin
                            balance <= balance + 5;
                        end else begin
                            balance <= MAX_COIN;
                        end
                    end else if (intf.coin_in==4) begin
                        if ((balance + 10) <= MAX_COIN) begin
                            balance <= balance + 10;
                        end else begin
                            balance <= MAX_COIN;
                        end
                    end else if (intf.coin_in==5) begin
                        if ((balance + 20) <= MAX_COIN) begin
                            balance <= balance + 20;
                        end else begin
                            balance <= MAX_COIN;
                        end
                    end else if ((intf.coin_in == 0) && (intf.button_in == 1) && (balance >= 3)) begin
                        balance <= balance - 3;
                        state <= WATER;
                    end else if ((intf.coin_in == 0) && (intf.button_in == 2) && (balance >= 5)) begin
                        balance <= balance - 5;
                        state <= SODA;
                    end

                WATER:
                    if (T_clk_cycle >= N) begin
                        state <= CALC_CHANGE;
                    end else begin
                        T_clk_cycle <= T_clk_cycle + 1;
                    end
                SODA:
                    if (T_clk_cycle >= N) begin
                        state <= CALC_CHANGE;
                    end else begin
                        T_clk_cycle <= T_clk_cycle + 1;
                    end

                CALC_CHANGE:
                    if (T_clk_cycle >= M) begin
                        state <= RETURN_CHANGE;
                    end else begin
                        T_clk_cycle <= T_clk_cycle + 1;
                    end
                
                RETURN_CHANGE:
                   
                    if(balance == 1 || balance == 2) begin 
                        balance <= 5'b00000; // reset the balance
                        T_clk_cycle <= 10'b0000000000; // reset the time for M and N
                        state <= START; // not reset the balance
                    end else begin
                        T_clk_cycle <= 10'b0000000000; // reset the time for M and N
                        state <= START; // not reset the balance
                    end
                default:
                    state <= INIT;

            endcase
        end
    end

    // Output register logic
    // inside every state show the specific outputs 
    always_comb begin
        case(state)
            INIT:
                begin
                    change = 0;
                    beverage = 0;
                end
            START:
                begin
                    change = 0;
                    beverage = 0;
                end 
            WATER:
                begin
                    change = 0;
                    beverage = 1;
                end 
            SODA: 
                begin
                    change = 0;
                    beverage = 2;
                end
            CALC_CHANGE:
                begin
                    change = 0;
                    beverage = 0;
                end     
            RETURN_CHANGE:
                if(balance == 1) begin
                    change = 1;
                    beverage = 0;
                end else if (balance == 2) begin
                    change = 2;
                    beverage = 0;
                end else begin
                    change = 0;
                    beverage = 0;
                end
                
        endcase
    end

    // connect the register to output wire
    assign intf.change_out = change;
    assign intf.beverage_out = beverage;

endmodule

