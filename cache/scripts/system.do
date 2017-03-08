onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -group rfif /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -expand -group IF /system_tb/DUT/CPU/DP/prif/IF_instruction_in
add wave -noupdate -expand -group IF /system_tb/DUT/CPU/DP/prif/IF_pc_add4_in
add wave -noupdate -expand -group IF /system_tb/DUT/CPU/DP/prif/IF_instruction_out
add wave -noupdate -expand -group IF /system_tb/DUT/CPU/DP/prif/IF_pc_add4_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_ALUSrc_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_RegDst_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_RegWEN_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_aluop_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_regWsel_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_PCSrc_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_dWEN_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_halt_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rdat1_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rdat2_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_MemToReg_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_dREN_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_imm_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_shamt_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rs_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rt_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rd_in
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_instruction_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_pc_add4_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_RegDst_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_RegWEN_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_aluop_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_ALUSrc_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_regWsel_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_PCSrc_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_dWEN_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_halt_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rdat1_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rdat2_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_MemToReg_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_dREN_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_imm_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_shamt_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rs_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rt_out
add wave -noupdate -group ID /system_tb/DUT/CPU/DP/prif/ID_rd_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_zero_in
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_port_out_in
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_result_in
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_WriteData_in
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_WriteData_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_instruction_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_PCSrc_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_pc_add4_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_dWEN_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_port_out_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_RegWEN_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_rdat2_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_rdat1_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_regWsel_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_halt_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_result_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_zero_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_RegDst_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_MemToReg_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_dREN_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_imm_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_shamt_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_rs_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_rt_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/prif/EX_rd_out
add wave -noupdate -expand -group EX /system_tb/DUT/CPU/DP/PR/prif/EX_predict_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_dmemload_in
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_instruction_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_PCSrc_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_pc_add4_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_dmemload_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_regWsel_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_RegWEN_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_result_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_halt_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_RegDst_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_MemToReg_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_dWEN_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_dREN_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_imm_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_shamt_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_rs_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_rt_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_rd_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_port_out_out
add wave -noupdate -group MEM /system_tb/DUT/CPU/DP/prif/MEM_ALUSrc_out
add wave -noupdate /system_tb/DUT/CPU/DP/RF/regs
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/EX_reg
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/MEM_reg
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/EX_forward
add wave -noupdate -group huif /system_tb/DUT/CPU/DP/huif/MEM_forward
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/PCEN
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/npc
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/pc
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/new_pc
add wave -noupdate -expand -group Predict /system_tb/DUT/CPU/DP/piif/EX_instruction_out
add wave -noupdate -expand -group Predict /system_tb/DUT/CPU/DP/piif/PCEN
add wave -noupdate -expand -group Predict /system_tb/DUT/CPU/DP/piif/flush
add wave -noupdate -expand -group Predict /system_tb/DUT/CPU/DP/piif/prediction_level
add wave -noupdate -expand -group Predict /system_tb/DUT/CPU/DP/piif/next_prediction
add wave -noupdate -expand -group Predict /system_tb/DUT/CPU/DP/piif/predict
add wave -noupdate -expand -group BTB /system_tb/DUT/CPU/DP/btbif/pc
add wave -noupdate -expand -group BTB /system_tb/DUT/CPU/DP/btbif/EX_pc_add4_out
add wave -noupdate -expand -group BTB /system_tb/DUT/CPU/DP/btbif/EX_instruction_out
add wave -noupdate -expand -group BTB /system_tb/DUT/CPU/DP/btbif/PCEN
add wave -noupdate -expand -group BTB /system_tb/DUT/CPU/DP/btbif/npc_branch
add wave -noupdate -expand -group BTB /system_tb/DUT/CPU/DP/btbif/branch_found
add wave -noupdate -expand -group BTB /system_tb/DUT/CPU/DP/btbif/branch_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1064732 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 193
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
configure wave -timelineunits ns
update
WaveRestoreZoom {676 ns} {2028 ns}
