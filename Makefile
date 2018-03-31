all: instructionMemory alu control regfile muxprealu instructionRegister
	# 
instructionMemory: instructionMemory.v
	iverilog -o instructionMemory.vvp instructionMemory.v
alu: alu.v
	iverilog -o alu.vvp alu.v
instructionRegister: instructionRegister.v
	iverilog -o instructionRegister.vvp instructionRegister.v
muxprealu: MUXpreALU.v
	iverilog -o MUXpreALU.vvp MUXpreALU.v
regfile: registerFile.v
	iverilog -o registerFile.vvp registerFile.v
control: controllerFSM.v
	iverilog -o controllerFSM.vvp controllerFSM.v
graph: controllerFSM.vvp controllerFSM.vcd
	gtkwave controllerFSM.vcd
clean:
	rm -f *.vvp
