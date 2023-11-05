set_attr lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib
set_attr hdl_search_path /home/DIGITAL_ASIC_LAB/m23eev006
set_attr library slow.lib
read_hdl main.v
elaborate
# This one adds constraints in your design (Either pass it with read.sdc or directly in script.)
# Set input delays (assumed 2ns setup and hold times)
set_input_delay -max 2 [get_ports A]
set_input_delay -max 2 [get_ports B]
set_input_delay -max 2 [get_ports Mode]

# Set output delays (assumed 2ns delay)
set_output_delay 2 [get_ports Result]
syn_generic
write_hdl
syn_map
write_hdl
report_area
syn
syn_opt
write_hdl
report_area
report_area
report_gates
report_gates -power
report_timing
report timing > matrix.rep
report power > matrix.rep
report area > matrix.rep
write_hdl > matrix.v
write_sdc > matrix.sdc
gui_show
