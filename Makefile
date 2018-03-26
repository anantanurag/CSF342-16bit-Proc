all: control
	# 
control: controllerFSM.v
	iverilog -o controllerFSM.vvp controllerFSM.v
graph: controllerFSM.vvp controllerFSM.vcd
	gtkwave controllerFSM.vcd
clean:
	rm -f *.vvp
