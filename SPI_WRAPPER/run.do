vlib work
vlog -f src_files.list +define+SIM +cover +covercells +coveropt
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

add wave /top/wrapperif/*
add wave -r /top/DUT1/SLAVE_instance/cs
add wave -r /top/DUT1/SLAVE_instance/ns
add wave -r /top/DUT1/RAM_instance/MEM
add wave /top/DUT1/assert__p_reset_outputs_inactive
add wave /top/DUT1/assert__stable_miso


run -all