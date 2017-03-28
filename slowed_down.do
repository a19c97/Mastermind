vlib work
vlog -timescale 1ns/1ns mastermind.v
vsim mastermind
log {/*}
add wave {/*}

#test case 1

force {CLOCK_50} 0 0, 1 1 -repeat 2
force {SW[2:0]} 000 0, 011 22, 010 46, 011 54, 111 62
force {KEY[0]} 1 0, 0 38, 1 46, 0 54, 1 62
force {KEY[1]} 1 0, 0 5, 1 22
force {KEY[2]} 1 0, 0 1, 1 4
run 110ns
