vlib work
vlog -timescale 1ns/1ns mastermind.v
vsim mastermind
log {/*}
add wave {/*}

force {CLOCK_50} 1 0, 0 5 -repeat 10

force {KEY[2]} 0
force {KEY[1]} 0
force {KEY[0]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 0
run 20ns


# Load code

force {KEY[2]} 1
force {KEY[1]} 1
force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 1
run 20ns

force {KEY[0]} 0
run 20ns

force {KEY[0]} 1
run 20ns



force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 20ns

force {KEY[0]} 0
run 20ns

force {KEY[0]} 1
run 20ns



force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 1
run 20ns

force {KEY[0]} 0
run 20ns

force {KEY[0]} 1
run 20ns



force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 20ns

force {KEY[0]} 0
run 20ns

force {KEY[0]} 1
run 20ns




# Erase code

run 20ns

force {KEY[0]} 0
run 20ns

force {KEY[0]} 1
run 20ns




# Load guess 1

force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 1
run 20ns

force {KEY[0]} 0
run 20ns

force {KEY[0]} 1
run 20ns



force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 0
run 20ns

force {KEY[0]} 0
run 20ns

force {KEY[0]} 1
run 20ns



force {SW[2]} 0
force {SW[1]} 1
force {SW[0]} 1
run 20ns

force {KEY[0]} 0
run 20ns

force {KEY[0]} 1
run 20ns



force {SW[2]} 1
force {SW[1]} 1
force {SW[0]} 1
run 20ns

force {KEY[0]} 0
run 20ns

force {KEY[0]} 1
run 20ns

run 150ns
