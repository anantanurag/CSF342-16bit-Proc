all: control regfile muxprealu
	# 
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
