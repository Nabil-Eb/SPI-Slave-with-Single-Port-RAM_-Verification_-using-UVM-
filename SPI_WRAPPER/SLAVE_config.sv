package SLAVE_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class SLAVE_config extends uvm_object;
        `uvm_object_utils(SLAVE_config)
        virtual SLAVE_if SLAVE_vif ;
        uvm_active_passive_enum is_active;
        function new(string name = "SLAVE_config");
            super.new(name) ;
        endfunction
    endclass 
endpackage