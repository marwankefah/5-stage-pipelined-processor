mem load -filltype value -filldata 0001110100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(16)
mem load -filltype value -filldata 0001110110000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(17)
mem load -filltype value -filldata 0001111000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(18)
mem load -filltype value -filldata 1100100010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(19)
mem load -filltype value -filldata 0000000011110101 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(20)
mem load -filltype value -filldata 0100000010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(21)
mem load -filltype value -filldata 0100000100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(22)
mem load -filltype value -filldata 0100010010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(23)
mem load -filltype value -filldata 0100010100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(24)
mem load -filltype value -filldata 1101000100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(25)
mem load -filltype value -filldata 0000001000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(26)
mem load -filltype value -filldata 1101000010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(27)
mem load -filltype value -filldata 0000001000000010 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(28)
mem load -filltype value -filldata 1100110110000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(29)
mem load -filltype value -filldata 0000001000000010 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(30)
mem load -filltype value -filldata 1100111000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(31)
mem load -filltype value -filldata 0000001000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(32)
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
run 250 ps
force -freeze sim:/processor/IN_PORT 32'h0CDAFE19 0
run
force -freeze sim:/processor/IN_PORT 32'h0000FFFF 0
run
force -freeze sim:/processor/IN_PORT 32'h0000F320 0
run 1400 ps