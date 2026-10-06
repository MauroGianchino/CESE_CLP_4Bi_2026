onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 80 /mod_ppm_tb/clk_tb
add wave -noupdate -height 80 /mod_ppm_tb/rst_tb
add wave -noupdate -height 80 /mod_ppm_tb/rx_data_tb
add wave -noupdate -height 80 /mod_ppm_tb/rx_data_rdy_tb
add wave -noupdate -height 80 /mod_ppm_tb/ppm_tb
add wave -noupdate -height 80 /mod_ppm_tb/sync_tb
add wave -noupdate /mod_ppm_tb/DUT/empty_msg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9053892 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 191
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {12323353 ps}
