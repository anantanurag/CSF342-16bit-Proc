all: test muxPC TOP programCounter MemoryDataRegister dataMemory instructionMemory alu control regfile muxprealu instructionRegister
	# 
test:
	iverilog -o tb_TOP.vvp tb_TOP.v
	vvp tb_TOP.vvp
	gtkwave TOP.vcd
muxPC:
	iverilog -o iverilog_output_files/muxPC.vvp muxPC.v
TOP: TOP.v
	iverilog -o iverilog_output_files/TOP.vvp TOP.v
programCounter: programCounter.v
	iverilog -o iverilog_output_files/programCounter.vvp programCounter.v
memoryDataRegister: memoryDataRegister.v
	iverilog -o iverilog_output_files/memoryDataRegister.vvp memoryDataRegister.v
dataMemory: dataMemory.v
	iverilog -o iverilog_output_files/dataMemory.vvp dataMemory.v
instructionMemory: instructionMemory.v
	iverilog -o iverilog_output_files/instructionMemory.vvp instructionMemory.v
alu: alu.v
	iverilog -o iverilog_output_files/alu.vvp alu.v
instructionRegister: instructionRegister.v
	iverilog -o iverilog_output_files/instructionRegister.vvp instructionRegister.v
muxprealu: MUXpreALU.v
	iverilog -o iverilog_output_files/MUXpreALU.vvp MUXpreALU.v
regfile: registerFile.v
	iverilog -o iverilog_output_files/registerFile.vvp registerFile.v
control: controllerFSM.v
	iverilog -o iverilog_output_files/controllerFSM.vvp controllerFSM.v
graph: tb_TOP.vvp TOP.vcd
	gtkwave TOP.vcd
clean:
	rm -f *.vvp
