module RAM_sva(    
    input [9:0] din,
    input clk, rst_n, rx_valid,
    input [7:0] dout,
    input tx_valid
    );

    // 1) reset
    property p_reset;
        @(posedge clk)
            (!rst_n) |=> (dout == 0 && tx_valid == 0);
    endproperty
    a_reset: assert property (p_reset)
        else $error("Assertion 1 failed");
    c_reset: cover property (p_reset);

    // 2) tx_valid is low 
    property p_tx_low;
        @(posedge clk) disable iff (!rst_n)
        ( (!din[9]) && (!din[8]) && rx_valid) |=> (tx_valid == 0);
    endproperty
    a_tx_low: assert property (p_tx_low)
        else $error("Assertion 2 failed");
    c_tx_low: cover property (p_tx_low);

    // 3) tx_valid rises then falls
    property p_tx_high;
        @(posedge clk) disable iff (!rst_n)
            ((din[8] && din[9]) && rx_valid) |=> (tx_valid == 1) |=> $fell(tx_valid)[->1] ;
    endproperty
    a_tx_high: assert property (p_tx_high) 
    else $error("Assertion 3 failed");
    c_tx_high: cover property (p_tx_high);
    
    // 4) write address => write data
    property p_write;
        @(posedge clk) disable iff (!rst_n)
            (rx_valid && din[9:8] == 2'b00) |=>##1 (din[9:8] inside {2'b00,2'b01});
    endproperty
    a_write: assert property (p_write) else $error("Assertion write failed");
    c_write: cover property (p_write);

    // 5) read address => read data
    property p_read;
        @(posedge clk) disable iff (!rst_n)
            (din[9:8] == 2'b10) |=>##[0:2] ( din[9:8] inside {2'b10,2'b11});
    endproperty
    a_read: assert property (p_read) else $error("Assertion read failed ");
    c_read: cover property (p_read);

endmodule