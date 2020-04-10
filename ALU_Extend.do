vsim -gui work.alu_extend(alu_extend_archi)
add wave sim:/alu_extend/*
force -freeze sim:/alu_extend/RD1 32'h00FF 0
force -freeze sim:/alu_extend/RD2 32'h00AA 0
force -freeze sim:/alu_extend/RD2N 32'h00EE 0
force -freeze sim:/alu_extend/CCRin 3'b111 0
force -freeze sim:/alu_extend/A 2'h00 0
force -freeze sim:/alu_extend/B 2'h00 0
force -freeze sim:/alu_extend/Op2S 2'h00 0
force -freeze sim:/alu_extend/ALUop 3'h000 0
force -freeze sim:/alu_extend/stC 1 0
force -freeze sim:/alu_extend/clC 0 0
force -freeze sim:/alu_extend/clF 0 0
force -freeze sim:/alu_extend/enF 0 0
force -freeze sim:/alu_extend/FlagS 0 0
force -freeze sim:/alu_extend/ALUr 32'h00CC 0
force -freeze sim:/alu_extend/IMMe 32'h00BB 0
force -freeze sim:/alu_extend/WB 32'h00DD 0
run
force -freeze sim:/alu_extend/stC 1 0
force -freeze sim:/alu_extend/enF 1 0
run
force -freeze sim:/alu_extend/clC 1 0
force -freeze sim:/alu_extend/stC 0 0
run
force -freeze sim:/alu_extend/stC 1 0
force -freeze sim:/alu_extend/clC 0 0
run
force -freeze sim:/alu_extend/stC 0 0
force -freeze sim:/alu_extend/clC 0 0
force -freeze sim:/alu_extend/clF 1 0
force -freeze sim:/alu_extend/enF 0 0
run
force -freeze sim:/alu_extend/clF 1 0
force -freeze sim:/alu_extend/enF 1 0
run
force -freeze sim:/alu_extend/clF 0 0
force -freeze sim:/alu_extend/RD1 32'hFFFFFFFF 0
force -freeze sim:/alu_extend/RD2 32'h00000000 0
run
force -freeze sim:/alu_extend/RD1 32'h00000000 0
force -freeze sim:/alu_extend/RD2 32'h00000000 0
run
force -freeze sim:/alu_extend/RD1 32'h10000000 0
force -freeze sim:/alu_extend/RD2 32'h10000000 0
run
force -freeze sim:/alu_extend/RD1 32'hFFFFFFFF 0
force -freeze sim:/alu_extend/RD2 32'h00000000 0
force -freeze sim:/alu_extend/ALUop 3'b100 0
run
force -freeze sim:/alu_extend/Op2S 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run
force -freeze sim:/alu_extend/Op2S 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b001 0
run
force -freeze sim:/alu_extend/ALUop 3'b111 0
run
force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b111 0
run
force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run

force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run


force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b001 0
run

force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b010 0
run

force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b011 0
run
force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b101 0
run

force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b110 0
run
run
run
run
run
force -freeze sim:/alu_extend/clF 1 0
force -freeze sim:/alu_extend/enF 1 0
run
force -freeze sim:/alu_extend/clF 0 0
force -freeze sim:/alu_extend/A 2'b01 0
force -freeze sim:/alu_extend/B 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b100 0
run
force -freeze sim:/alu_extend/Op2S 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run
force -freeze sim:/alu_extend/Op2S 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b001 0
run
force -freeze sim:/alu_extend/ALUop 3'b111 0
run
force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b111 0
run
force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run

force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run


force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b001 0
run

force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b010 0
run

force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b011 0
run
force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b101 0
run

force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b110 0
run
run
run
run
run
force -freeze sim:/alu_extend/clF 1 0
force -freeze sim:/alu_extend/enF 1 0
run
force -freeze sim:/alu_extend/clF 0 0
force -freeze sim:/alu_extend/A 2'b11 0
force -freeze sim:/alu_extend/B 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b100 0
run
force -freeze sim:/alu_extend/Op2S 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run
force -freeze sim:/alu_extend/Op2S 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b001 0
run
force -freeze sim:/alu_extend/ALUop 3'b111 0
run
force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b111 0
run
force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run

force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run


force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b001 0
run

force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b010 0
run

force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b011 0
run
force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b101 0
run

force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b110 0
run
run
run
run
run
force -freeze sim:/alu_extend/clF 1 0
force -freeze sim:/alu_extend/enF 1 0
run
force -freeze sim:/alu_extend/clF 0 0
force -freeze sim:/alu_extend/A 2'b10 0
force -freeze sim:/alu_extend/B 2'b11 0
force -freeze sim:/alu_extend/ALUop 3'b100 0
run
force -freeze sim:/alu_extend/Op2S 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run
force -freeze sim:/alu_extend/Op2S 2'b01 0
force -freeze sim:/alu_extend/ALUop 3'b001 0
run
force -freeze sim:/alu_extend/ALUop 3'b111 0
run
force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b111 0
run
force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run

force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b000 0
run


force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b001 0
run

force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b010 0
run

force -freeze sim:/alu_extend/Op2S 2'b00 0
force -freeze sim:/alu_extend/ALUop 3'b011 0
run
force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b101 0
run

force -freeze sim:/alu_extend/Op2S 2'b10 0
force -freeze sim:/alu_extend/ALUop 3'b110 0
run
force -freeze sim:/alu_extend/A 2'h1 0
run
force -freeze sim:/alu_extend/Op2S 2'h0 0
force -freeze sim:/alu_extend/ALUop 3'h0 0
run
force -freeze sim:/alu_extend/Op2S 2'h 0
force -freeze sim:/alu_extend/Op2S 2'h1 0
run
force -freeze sim:/alu_extend/B 2'h0 0
run
force -freeze sim:/alu_extend/ALUop 3'h 0
force -freeze sim:/alu_extend/ALUop 3'h1 0
run
force -freeze sim:/alu_extend/ALUop 3'h2 0
run
force -freeze sim:/alu_extend/B 2'h1 0
run
force -freeze sim:/alu_extend/B 2'h3 0
run
force -freeze sim:/alu_extend/ALUop 3'h3 0
run
