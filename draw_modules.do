vlib work
vlog -timescale 1ns/1ns draw_modules.v
vsim small_squares
log {/*}
add wave {/*}

force {clock} 1 0, 0 1 -repeat 2

force {resetn} 0
force {enable} 0
force {peg_count[2]} 1
force {peg_count[1]} 0
force {peg_count[2]} 0

run 2ns

force {resetn} 1
force {enable} 1

run 300ns

