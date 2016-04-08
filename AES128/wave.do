onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /aes_tb/rst
add wave -noupdate /aes_tb/clk
add wave -noupdate /aes_tb/key_in
add wave -noupdate /aes_tb/d_in
add wave -noupdate /aes_tb/d_out
add wave -noupdate /aes_tb/d_vld
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3416 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 222
configure wave -valuecolwidth 125
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2723 ns} {2880 ns}
