package RAM_read_write_seq_pkg ;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class RAM_read_write_seq extends uvm_sequence #(RAM_seq_item) ;
    `uvm_object_utils(RAM_read_write_seq)

    RAM_seq_item seq_item ;
    RAM_seq_item seq_item2 ;

    function new (string name = "RAM_read_write_seq");
        super.new(name);
    endfunction

    task body();
        seq_item = RAM_seq_item::type_id::create("seq_item");
        repeat(10000) begin
            start_item(seq_item);
            seq_item.constraint_mode(0);
            seq_item.c_rx.constraint_mode(1);
            seq_item.c_rst.constraint_mode(1);
            seq_item.c_read_write.constraint_mode(1);
            assert (seq_item.randomize()); 
            finish_item(seq_item);
        end
    endtask 
 endclass
endpackage