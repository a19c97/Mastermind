vlib work

vlog -timescale 1ns/1ns compare.v

vsim compare

log {/*}

add wave {/*}


force {clock} 1 0, 0 5 -repeat 10

force {resetn} 0

run 10ns


force {resetn} 1

force {compareEn} 1

force {guess[0]} 1
force {guess[1]} 1
force {guess[2]} 0
force {guess[3]} 0
force {guess[4]} 0
force {guess[5]} 1
force {guess[6]} 0
force {guess[7]} 1
force {guess[8]} 0
force {guess[9]} 1
force {guess[10]} 0
force {guess[11]} 1


force {compare_i[0]} 0
force {compare_i[1]} 0

force {curr_code[0]} 0
force {curr_code[1]} 0
force {curr_code[2]} 1

run 10ns


force {compare_i[0]} 1
force {compare_i[1]} 0

force {curr_code[0]} 0
force {curr_code[1]} 1
force {curr_code[2]} 0

run 10ns


force {compare_i[0]} 0
force {compare_i[1]} 1

force {curr_code[0]} 1
force {curr_code[1]} 0
force {curr_code[2]} 1

run 10ns


force {compare_i[0]} 1
force {compare_i[1]} 1

force {curr_code[0]} 1
force {curr_code[1]} 0
force {curr_code[2]} 1

run 30ns
