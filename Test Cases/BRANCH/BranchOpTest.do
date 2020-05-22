mem load -filltype value -filldata 0001110010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(16)
mem load -filltype value -filldata 0001110100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(17)
mem load -filltype value -filldata 0001110110000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(18)
mem load -filltype value -filldata 0001111000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(19)
mem load -filltype value -filldata 0001111110000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(20)
mem load -filltype value -filldata 0100001000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(21)
mem load -filltype value -filldata 0110110010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(22)
mem load -filltype value -filldata 0001001110000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(23)
mem load -filltype value -filldata 0011001011010010 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(48)
mem load -filltype value -filldata 0110000100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(49)
mem load -filltype value -filldata 0001001110000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(50)
mem load -filltype value -filldata 0110000010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(80)
mem load -filltype value -filldata 0110100110000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(81)
mem load -filltype value -filldata 0000111010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(82)
mem load -filltype value -filldata 0001111100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(83)
mem load -filltype value -filldata 0110011100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(84)
mem load -filltype value -filldata 0001000010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(85)
mem load -filltype value -filldata 0000100000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(256)
mem load -filltype value -filldata 0011000000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(257)
mem load -filltype value -filldata 0001101100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(258)
mem load -filltype value -filldata 0111100000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(259)
mem load -filltype value -filldata 0100011100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(512)
mem load -filltype value -filldata 0111001100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(513)
mem load -filltype value -filldata 0001001100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(514)
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(515)
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(516)
mem load -filltype value -filldata 0010011101100110 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(768)
mem load -filltype value -filldata 0010010010100010 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(769)
mem load -filltype value -filldata 0111010000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(770)
mem load -filltype value -filldata 0001001110000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(771)
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(1280)
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(1281)
mem load -filltype value -filldata 0 -fillradix binary /processor/MEMORY_STAGE/datamem/dm_RAM/ram(0)
mem load -filltype value -filldata 10 -fillradix hexadecimal /processor/MEMORY_STAGE/datamem/dm_RAM/ram(1)
mem load -filltype value -filldata 0 -fillradix binary /processor/MEMORY_STAGE/datamem/dm_RAM/ram(2)
mem load -filltype value -filldata 100 -fillradix hexadecimal /processor/MEMORY_STAGE/datamem/dm_RAM/ram(3)
add wave -position insertpoint  \
sim:/processor/Decode_Stage/regfile/R0/q
add wave -position insertpoint  \
sim:/processor/Decode_Stage/regfile/R1/q
add wave -position insertpoint  \
sim:/processor/Decode_Stage/regfile/R2/q
add wave -position insertpoint  \
sim:/processor/Decode_Stage/regfile/R3/q
add wave -position insertpoint  \
sim:/processor/Decode_Stage/regfile/R4/q
add wave -position insertpoint  \
sim:/processor/Decode_Stage/regfile/R5/q
add wave -position insertpoint  \
sim:/processor/Decode_Stage/regfile/R6/q
add wave -position insertpoint  \
sim:/processor/Decode_Stage/regfile/R7/q
add wave  \
sim:/processor/Fetch_Stage/pcReg/q
add wave  \
sim:/processor/MEMORY_STAGE/u_SP/SP
add wave -position insertpoint  \
sim:/processor/EX_STAGE/CCR_REG_EX/Q_CCR
add wave -position insertpoint  \
sim:/processor/Reset
add wave -position insertpoint  \
sim:/processor/INTR_IN
add wave -position insertpoint  \
sim:/processor/CLK
add wave -position insertpoint  \
sim:/processor/IN_PORT \
sim:/processor/OUT_PORT
force -freeze sim:/processor/CLK 0 0, 1 {50 ps} -r 100
force -freeze sim:/processor/Reset 1 0
force -freeze sim:/processor/INTR_IN 0 0
run
force -freeze sim:/processor/Reset 0 0
run 300 ps
force -freeze sim:/processor/IN_PORT 32'h00000030 0
run
force -freeze sim:/processor/IN_PORT 32'h00000050 0
run
force -freeze sim:/processor/IN_PORT 32'h00000100 0
run
force -freeze sim:/processor/IN_PORT 32'h00000300 0
run
force -freeze sim:/processor/IN_PORT 32'hFFFFFFFF 0
run