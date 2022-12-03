###############################################################################
# Created by write_sdc
# Wed Nov 10 16:52:52 2021
###############################################################################
current_design $::env(DESIGN_NAME)
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name core_clock  -period $::env(CLOCK_PERIOD) [get_ports {core_clock}]
create_clock -name io_clock    -period $::env(CLOCK_PERIOD) [get_ports {io_clock}]
create_clock -name clock_out_a -period $::env(CLOCK_PERIOD) [get_ports {clock_out_a}]
create_clock -name clock_out_b -period $::env(CLOCK_PERIOD) [get_ports {clock_out_b}]
create_clock -name clock_out_c -period $::env(CLOCK_PERIOD) [get_ports {clock_out_c}]


puts "\[INFO\]: Setting clock transition to: $::env(SYNTH_CLOCK_TRANSITION)"
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [all_clocks]
puts "\[INFO\]: Setting clock uncertainity setup to: 0.5000"
set_clock_uncertainty -setup 0.5000 [all_clocks]
puts "\[INFO\]: Setting clock uncertainity hold to: 0.2500"
set_clock_uncertainty -hold 0.500 [all_clocks]


set ::env(SYNTH_TIMING_DERATE) 0.05
puts "\[INFO\]: Setting timing derate to: [expr {$::env(SYNTH_TIMING_DERATE) * 10}] %"
set_timing_derate -early [expr {1-$::env(SYNTH_TIMING_DERATE)}]
set_timing_derate -late [expr {1+$::env(SYNTH_TIMING_DERATE)}]


set input_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
set output_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
puts "\[INFO\]: Setting output delay to: $output_delay_value"
puts "\[INFO\]: Setting input delay to: $input_delay_value"


set_max_fanout $::env(SYNTH_MAX_FANOUT) [current_design]

set_input_delay $input_delay_value -clock [get_clocks {core_clock}] -max -add_delay [get_ports la_oenb]

if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL)] } {
    set ::env(SYNTH_CLK_DRIVING_CELL) $::env(SYNTH_DRIVING_CELL)
}

if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL_PIN)] } {
    set ::env(SYNTH_CLK_DRIVING_CELL_PIN) $::env(SYNTH_DRIVING_CELL_PIN)
}

###############################################################################
# Environment
###############################################################################

set_driving_cell -lib_cell $::env(SYNTH_CLK_DRIVING_CELL) -pin $::env(SYNTH_CLK_DRIVING_CELL_PIN) [get_ports {clock_out_a}]
set_driving_cell -lib_cell $::env(SYNTH_CLK_DRIVING_CELL) -pin $::env(SYNTH_CLK_DRIVING_CELL_PIN) [get_ports {clock_out_b}]
set_driving_cell -lib_cell $::env(SYNTH_CLK_DRIVING_CELL) -pin $::env(SYNTH_CLK_DRIVING_CELL_PIN) [get_ports {clock_out_c}]

set cap_load [expr $::env(SYNTH_CAP_LOAD) / 1000.0]
puts "\[INFO\]: Setting load to: $cap_load"
set_load  $cap_load [all_outputs]

###############################################################################
# Design Rules
###############################################################################

#disable clock gating check at static clock select pins
#set_false_path -through [get_pins u_cpu_ref_sel.u_mux/S]
#set_false_path -through [get_pins u_cpu_clk_sel.u_mux/S]
#set_false_path -through [get_pins u_wbs_clk_sel.u_mux/S]
#set_false_path -through [get_pins u_usb_clk_sel.u_mux/S]
























