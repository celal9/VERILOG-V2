# VERILOG-V2
Polynomial Memory and CENG Accumulator
For first part, i implemented basic memories as 2 Verilog modules. The modules together take a
binary number and an operation type (read/write) and then according to the operation type, either evaluate and
store the result of the evaluations to the given memory index (write mode) or return the previous data from the
given index of the memory (read mode).
For second part, i implemented a continuous accumulator chip for generic usage. Accumulator is required to execute loaded instructions on an infinite loop. In order to achieve this, accumulator
has two modes, Load Mode and Calculate Mode. In load mode, user will give “instruction code - value pairs” that
will be loaded to the memory of the chip. In calculate mode, these series of instruction value pairs will be calculated
one by one. When all of the instructions are exhausted, chip will start from the beginning. Instruction code will
be refereed as op (operation) code from now on
