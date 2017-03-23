vlib work

vlog -timescale 1ns/1ns data_path.v

vsim datapath

log {/*}

add wave {/*}


force {clk} 1 0, 0 5 -repeat 10

force {resetn} 0

force {data_in[0]} 0
force {data_in[1]} 0
force {data_in[2]} 0

force {load_code_1} 0
force {load_code_2} 0
force {load_code_3} 0
force {load_code_4} 0

force {load_guess_1} 0
force {load_guess_2} 0
force {load_guess_3} 0
force {load_guess_4} 0

force {compare_i[0]} 0
force {compare_i[1]} 0
force {compare} 0

force {reach_result_4} 0
force {resetRedWhite} 0

run 10ns


force {resetn} 1

force {data_in[0]} 1
force {data_in[1]} 0
force {data_in[2]} 0

force {load_code_1} 1

run 10ns


force {load_code_1} 0

run 10ns


force {data_in[0]} 0
force {data_in[1]} 1
force {data_in[2]} 0

force {load_code_2} 1

run 10ns


force {load_code_2} 0

run 10ns

force {data_in[0]} 1
force {data_in[1]} 1
force {data_in[2]} 0

force {load_code_3} 1

run 10ns


force {load_code_3} 0

run 10ns


force {data_in[0]} 0
force {data_in[1]} 0
force {data_in[2]} 1

force {load_code_4} 1

run 10ns


force {load_code_4} 0

run 10ns



force {data_in[0]} 0
force {data_in[1]} 0
force {data_in[2]} 1

force {load_guess_1} 1

run 10ns


force {load_guess_1} 0

run 10ns


force {data_in[0]} 1
force {data_in[1]} 1
force {data_in[2]} 0

force {load_guess_2} 1

run 10ns


force {load_guess_2} 0

run 10ns


force {data_in[0]} 0
force {data_in[1]} 1
force {data_in[2]} 0

force {load_guess_3} 1

run 10ns


force {load_guess_3} 0

run 10ns


force {data_in[0]} 1
force {data_in[1]} 0
force {data_in[2]} 0

force {load_guess_4} 1

run 10ns


force {load_guess_4} 0

run 10ns




force {compare_i[0]} 0
force {compare_i[1]} 0
force {compare} 1

run 10ns


force {compare_i[0]} 1
force {compare_i[1]} 0
force {compare} 1

run 10ns


force {compare_i[0]} 0
force {compare_i[1]} 1
force {compare} 1

run 10ns


force {compare_i[0]} 1
force {compare_i[1]} 1
force {compare} 1

run 10ns



force {compare_i[0]} 0
force {compare_i[1]} 0
force {compare} 0
force {reach_result_4} 1

run 10ns


force {load_guess_1} 1
force {reach_result_4} 0

run 10ns

