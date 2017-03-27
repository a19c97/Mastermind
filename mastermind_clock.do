vlib work
vlog -timescale 1ns/1ns mastermind_slow_clock.v
vsim slow_clock
log {/*}
add wave {/*}

force {clock} 0 0, 1 1 -repeat 2
force {reset_n} 1 0, 0 2, 1 4
run 100ns
