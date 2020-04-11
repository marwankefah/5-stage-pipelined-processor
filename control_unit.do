vsim control_unit
add wave -position insertpoint  \
sim:/control_unit/opcode \
sim:/control_unit/int \
sim:/control_unit/rst \
sim:/control_unit/op_signals \
sim:/control_unit/cntrl_sig
radix signal sim:/control_unit/op_signals hex
radix signal sim:/control_unit/cntrl_sig hex 
force -freeze sim:/control_unit/opcode 000000 0
force -freeze sim:/control_unit/int 0 0
force -freeze sim:/control_unit/rst 0 0
run 75 ps
force -freeze sim:/control_unit/opcode 000001 0
run 75 ps
force -freeze sim:/control_unit/opcode 000010 0
run 75 ps
force -freeze sim:/control_unit/opcode 000011 0
run 75 ps
force -freeze sim:/control_unit/opcode 000100 0
run 75 ps
force -freeze sim:/control_unit/opcode 000101 0
run 75 ps
force -freeze sim:/control_unit/opcode 000110 0
run 75 ps
force -freeze sim:/control_unit/opcode 000111 0
run 75 ps
force -freeze sim:/control_unit/opcode 001000 0
run 75 ps
force -freeze sim:/control_unit/opcode 001001 0
run 75 ps
force -freeze sim:/control_unit/opcode 101010 0
run 75 ps
force -freeze sim:/control_unit/opcode 001011 0
run 75 ps
force -freeze sim:/control_unit/opcode 001100 0
run 75 ps
force -freeze sim:/control_unit/opcode 001101 0
run 75 ps
force -freeze sim:/control_unit/opcode 101110 0
run 75 ps
force -freeze sim:/control_unit/opcode 101111 0
run 75 ps
force -freeze sim:/control_unit/opcode 010000 0
run 75 ps
force -freeze sim:/control_unit/opcode 010001 0
run 75 ps
force -freeze sim:/control_unit/opcode 110010 0
run 75 ps
force -freeze sim:/control_unit/opcode 110011 0
run 75 ps
force -freeze sim:/control_unit/opcode 110100 0
run 75 ps
force -freeze sim:/control_unit/opcode 011000 0
run 75 ps
force -freeze sim:/control_unit/opcode 011001 0
run 75 ps
force -freeze sim:/control_unit/opcode 011010 0
run 75 ps
force -freeze sim:/control_unit/opcode 011011 0
run 75 ps
force -freeze sim:/control_unit/opcode 011100 0
run 75 ps
force -freeze sim:/control_unit/opcode 011101 0
run 75 ps
force -freeze sim:/control_unit/opcode 011110 0
run 75 ps
force -freeze sim:/control_unit/int 1 0
run 75 ps
force -freeze sim:/control_unit/rst 1 0
run 75 ps
force -freeze sim:/control_unit/int 0 0
run 75 ps
force -freeze sim:/control_unit/rst 0 0
force -freeze sim:/control_unit/opcode 111111 0
run 75 ps