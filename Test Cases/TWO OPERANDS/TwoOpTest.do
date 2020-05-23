mem load -filltype value -filldata 0001110010000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(16)
mem load -filltype value -filldata 0001110100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(17)
mem load -filltype value -filldata 0001110110000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(18)
mem load -filltype value -filldata 0001111000000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(19)
mem load -filltype value -filldata 1010101010110000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(20)
mem load -filltype value -filldata 0000000000000010 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(21)
mem load -filltype value -filldata 0010011001000010 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(22)
mem load -filltype value -filldata 0010111101011000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(23)
mem load -filltype value -filldata 0011001101101110 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(24)
mem load -filltype value -filldata 0011010010010100 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(25)
mem load -filltype value -filldata 1011100100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(26)
mem load -filltype value -filldata 0000000000000010 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(27)
mem load -filltype value -filldata 1011110100000000 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(28)
mem load -filltype value -filldata 0000000000000011 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(29)
mem load -filltype value -filldata 0010000100001010 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(30)
mem load -filltype value -filldata 0010010100101010 -fillradix symbolic /processor/Fetch_Stage/I_mem/im_RAM/ram(31)
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
force -freeze sim:/processor/IN_PORT 32'h00000005 0
run
force -freeze sim:/processor/IN_PORT 32'h00000019 0
run
force -freeze sim:/processor/IN_PORT 32'h0000FFFD 0
run
force -freeze sim:/processor/IN_PORT 32'h0000F320 0
run 1400 ps