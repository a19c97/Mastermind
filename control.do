vlib work

vlog -timescale 1ns/1ns control.v

vsim control

log {/*}

add wave {/*}


force {clk} 1 0, 0 5 -repeat 10


force {resetn} 0

run 10ns


force {resetn} 0
force {load} 1

run 20ns


force {load} 0

run 20ns


force {load} 1

run 20ns


force {load} 0

run 20ns


force {load} 1

run 20ns


force {load} 0

run 20ns


force {load} 1

run 20ns


force {load} 0

run 20ns


run 60ns


force {load} 1

run 20ns


force {load} 0

run 20ns


force {load} 1

run 20ns


force {load} 0

run 20ns


force {load} 1

run 20ns


force {load} 0

run 20ns


force {load} 1

run 20ns


force {load} 0

run 20ns

run 60ns
