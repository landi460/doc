onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testcount/clk
add wave -noupdate -format Logic /testcount/reset
add wave -noupdate -format Logic /testcount/counten
add wave -noupdate -format Logic /testcount/owfl
add wave -noupdate -format Literal /testcount/countout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {261260 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {245260 ps} {277260 ps}
