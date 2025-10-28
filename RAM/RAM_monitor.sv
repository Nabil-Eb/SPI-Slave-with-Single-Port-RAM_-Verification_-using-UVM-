package RAM_monitor_pkg ;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class RAM_monitor extends uvm_monitor ;
    `uvm_component_utils(RAM_monitor)

    RAM_seq_item rsp_seq_item ;
    virtual RAM_intf RAM_vif ;
    uvm_analysis_port #(RAM_seq_item) mon_ap ;

    function new (string name = "RAM_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            rsp_seq_item = RAM_seq_item::type_id::create ("rsp_seq_item");
            
            rsp_seq_item.rst_n         = RAM_vif.rst_n ;
            rsp_seq_item.din           = RAM_vif.din ;
            rsp_seq_item.rx_valid      = RAM_vif.rx_valid ;
            rsp_seq_item.dout          = RAM_vif.dout ;
            rsp_seq_item.tx_valid      = RAM_vif.tx_valid ;
            rsp_seq_item.dout_ref      = RAM_vif.dout_ref ;
            rsp_seq_item.tx_valid_ref  = RAM_vif.tx_valid_ref ;
            
            @(negedge RAM_vif.clk);
            mon_ap.write(rsp_seq_item);
            `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
        end
    endtask 
 endclass
endpackage