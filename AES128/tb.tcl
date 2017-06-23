quit -sim
vlib work
vlog *.v
vsim aes_tb
#add wave *
do wave.do
view wave
run 3540 ns

