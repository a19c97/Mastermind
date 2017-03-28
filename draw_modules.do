vlib work
vlog -timescale 1ns/1ns draw_modules.v
vsim medium_square
log {/*}
add wave {/*}

force {clock} 1 0, 0 1 -repeat 2

force {resetn} 0
force {enable} 0

run 2ns

force {resetn} 1
force {enable} 1

run 300ns

