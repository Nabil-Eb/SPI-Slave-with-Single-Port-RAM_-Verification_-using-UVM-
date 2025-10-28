import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_test_pkg::*;
import SLAVE_test_pkg::*;
import RAM_test_pkg::*;

module top();
  bit clk;

  initial begin
    forever 
      #1 clk =~clk ;
  end

  wrapper_if wrapperif (clk);
  SLAVE_if slaveif (clk);
  RAM_if ramif (clk);

  // Instantiate the wrapper (which contains both RAM and SLAVE internally)
  wrapper DUT1 (wrapperif);

  // Golden model for wrapper
  golden_model_SPI_wrapper wrapper_ins (
      .MOSI_ref(wrapperif.MOSI),
      .MISO_ref(wrapperif.MISO_ref),
      .SS_n_ref(wrapperif.SS_n),
      .clk(wrapperif.clk),
      .rst_n_ref(wrapperif.rst_n)
  );

    bind DUT1.RAM_instance RAM_sva RAM_assertion (
      .clk(wrapperif.clk),
      .rst_n(wrapperif.rst_n),
      .tx_valid(wrapperif.tx_valid),
      .dout(wrapperif.tx_data),
      .din(wrapperif.rx_data),
      .rx_valid(wrapperif.rx_valid)
  );

  // Connect SLAVE interface to wrapper's internal SLAVE signals for monitoring
  assign slaveif.rst_n = wrapperif.rst_n;
  assign slaveif.SS_n = wrapperif.SS_n;
  assign slaveif.MOSI = wrapperif.MOSI;
  assign slaveif.MISO = wrapperif.MISO;
  assign slaveif.rx_data = DUT1.rx_data;
  assign slaveif.rx_valid = DUT1.rx_valid;
  assign slaveif.tx_data = DUT1.tx_data;
  assign slaveif.tx_valid = DUT1.tx_valid;

  // Connect RAM interface to wrapper's internal RAM signals for monitoring
  assign ramif.rst_n = wrapperif.rst_n;
  assign ramif.din = DUT1.rx_data;
  assign ramif.rx_valid = DUT1.rx_valid;
  assign ramif.dout = DUT1.tx_data;
  assign ramif.tx_valid = DUT1.tx_valid;

  // Connect RAM golden interface to wrapper's internal RAM signals for monitoring
  assign ramif.dout_ref = DUT1.tx_data;
  assign ramif.tx_valid_ref = DUT1.tx_valid;

  initial begin
    uvm_config_db #(virtual wrapper_if)::set(null, "uvm_test_top" , "WRAPPER_IF" ,wrapperif);
    uvm_config_db #(virtual SLAVE_if)::set(null, "uvm_test_top" , "SLAVE_IF" ,slaveif);
    uvm_config_db #(virtual RAM_if)::set(null, "uvm_test_top" , "RAM_IF" ,ramif);
    run_test("wrapper_test");
  end

endmodule