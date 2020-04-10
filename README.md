# 5-stage Pipelined Processor
<br>A simple 5-stage pipelined processor based on the Harvard Architecture.
## Introduction
  The processor in this project has a RISC-like instruction set architecture. There are eight 4-byte general purpose registers; R0, till R7. Another two general purpose registers, One works as program counter (PC). And the other, works as a stack pointer (SP).
The initial value of SP is (2^32-1). The memory address space is 4 GB of 16-bit width and is word addressable. ( N.B. word = 2 bytes).
The bus between memory and the processor is (16-bit or 32-bit) widths for instruction memory and 32-bit widths for data memory.

  When an interrupt occurs, the processor finishes the currently fetched instructions (instructions that have already entered the pipeline), then the address of the next instruction (in PC) is saved on top of the stack, and PC is loaded from address [2-3] of the memory (the address takes two words). To return from an interrupt, an RTI instruction loads PC from the top of stack, and the flow of the program resumes from the instruction after the interrupted instruction. Take care of corner cases like Branching,Push,POP.

## ISA Specifications
### A) Registers

| Register | Details |
| --- | --- |
| R[0:7]    <31:0> | Eight 32-bit general purpose registers                               |
| PC<31:0>  <31:0> | 32-bit program counter                                               |
| SP<31:0>  <31:0> | 32-bit stack pointer                                                 |
| CCR<3:0>         | condition code register                                              |
| Z<0>:=CCR<0>     | zero flag, change after arithmetic, logical, or shift operations     |
| N<0>:=CCR<1>     | negative flag, change after arithmetic, logical, or shift operations |
| C<0>:=CCR<2>     | carry flag, change after arithmetic or shift operations.             |

### B) Input-Output
| IN-OUT  | Details |
| --- | --- |
| IN.PORT<31:0>  | 32-bit data input port                  |
| OUT.PORT<31:0> | 32-bit data output port                 |
| INTR.IN<0>     | a single, non-maskable interrupt        |
| RESET.IN<0>    | reset signal                            |

### C) Abbreviation
| Abbrv  | Details |
| --- | --- |
| Rsrc1 | 1st operand register                             |
| Rsrc2 | 2st operand register                             |
| Rdst  | result register                                  |
| EA    | Effective address(20 bit)                        |
| Imm   | Immediate Value (16 bit)                         |

### D) Commands

| Mnemonic  | Function |
| --- | --- |
| NOP| PC ← PC + 1 |
| SETC | C ←1 |
| CLRC |  C ←0 |
| NOT Rdst | NOT value stored in register Rdst<br> R[ Rdst ] ← 1’s Complement(R[ Rdst ]);<br> If (1’s Complement(R[ Rdst ]) = 0): Z ←1; else: Z ←0;<br> If (1’s Complement(R[ Rdst ]) < 0): N ←1; else: N ←0 |
| INC Rdst | Increment value stored in Rdst<br> R[ Rdst ] ←R[ Rdst ] + 1;<br> If ((R[ Rdst ] + 1) = 0): Z ←1; else: Z ←0;<br> If ((R[ Rdst ] + 1) < 0): N ←1; else: N ←0 |
| DEC Rdst | Decrement value stored in Rdst<br> R[ Rdst ] ←R[ Rdst ] – 1;<br> If ((R[ Rdst ] – 1) = 0): Z ←1; else: Z ←0;<br> If ((R[ Rdst ] – 1) < 0): N ←1; else: N ←0 |
| OUT Rdst |  OUT.PORT ← R[ Rdst ] |
| IN Rdst |  R[ Rdst ] ←IN.PORT |
| SWAP Rsrc, Rdst | Store the value of Rsrc 1 in Rdst and the value of Rdst in Rsc1 flag shouldn’t change|
| ADD Rsrc1,Rsrc2,Rdst | Add the values stored in registers Rsrc1, Rsrc2 and store the result in Rdst <br>If the result =0 then Z ←1; else: Z ←0; <br> If the result <0 then N ←1; else: N ←0 |
| SUB Rsrc1,Rsrc2, Rdst| Subtract the values stored in registers Rsrc1, Rsrc2 and store the result in Rdst <br> If the result =0 then Z ←1; else: Z ←0; <br> If the result <0 then N ←1; else: N ←0|
|AND Rsrc1,Rsrc2, Rdst| AND the values stored in registers Rsrc1, Rsrc2 and store the result in Rdst <br>If the result =0 then Z ←1; else: Z ←0; <br> If the result <0 then N ←1; else: N ←0|
| OR Rsrc1,Rsrc2, Rdst| OR the values stored in registers Rsrc1, Rsrc2<br> and store the result in Rdst<br> If the result =0 then Z ←1; else: Z ←0;<br> If the result <0 then N ←1; else: N ←0 |
| SHL Rsrc, Imm, Rdst | Shift left Rsrc by #Imm bits and store result in Rdst;<br> Don’t forget to update carry|
| SHR Rsrc, Imm, Rdst | Shift right Rsrc by #Imm bits and store result in Rdst;<br> Don’t forget to update carry|
| PUSH Rdst |  M[SP--] ← R[ Rdst ]; |
| POP Rdst |  R[ Rdst ] ← M[++SP]; |
| LDM Rdst, Imm | Load immediate value (16 bit) to register Rdst<br> R[ Rdst ] ← {0,Imm<15:0>}|
| LDD Rdst, EA |  Load value from memory address EA to register <br> Rdst R[ Rdst ] ← M[EA]; |
| STD Rsrc, EA | Store value in register Rsrc to memory location EA <br> M[EA] ←R[Rsrc];|
| JZ Rdst | Jump if zero<br> If (Z=1): PC ←R[ Rdst ]; (Z=0) |
| JN Rdst | Jump if negative<br> If (N=1): PC ←R[ Rdst ]; (N=0) |
| JC Rdst | Jump if carry<br> If (C=1): PC ←R[ Rdst ]; (C=0): |
| JMP Rdst | Jump<br> PC ←R[ Rdst ] |
| CALL Rdst  | (M[SP] ← PC + 1; sp-2; PC ← R[ Rdst ])|
| RET |  sp+2, <br> PC ←M[SP] |
| RTI |  sp+2; PC ← M[SP];<br> Flags restored|

| Input Signal  | Function |
| --- | --- |
| Reset |PC ←{M[1], M[0]} //memory location of zero|
| Interrupt | M[Sp]←PC; sp-2;PC ← {M[3],M[2]}; <br> Flags preserved  |

## Design
### Instructions
Below is the full instruction list, as well as the **OpCode** composition for each instruction.
![Image of Full Final Instruction Set](https://i.ibb.co/wcRfCg0/ISet.png)
### Control Unit
Full control unit output truth table for each instruction
![Image of Full Final Control Unit Design](https://i.ibb.co/SX86fgK/Control-TT.png)
### Schema
Fully pipelined diagram illustrating the architecture of the processor, in addition to the layout of _control, hazard detection, interrupt handling and forwarding units_
![Image of Full Final Schema](https://i.ibb.co/XYq3XtQ/Pipelined-Hazard-Schema1-Pipelined-ctrl-frwrd-unit.png)
