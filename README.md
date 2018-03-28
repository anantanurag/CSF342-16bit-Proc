# CSF342-16bit-Proc
16 Bit RISC Processor


26 March 2018

Made Controller, with testing for proper state flows but not whether each control signal is correct or not. 
Will check individual control signals when they malfunction in the datapath!! States only tested for ADD Register type instruction, works decently. Will check for other instructions as and when they come up in the datapath.

-Anant

28 March 2018

Written Register file, slightly different from the original datapath diagram in chart due to pending decoding of the instruction. Concat blocks included in the same file but different module, selection muxes included inside the register file module!!!

Written Pre ALU MUX. This file contains combinational logic that will take place at the start of EX stage. All muxes and sign extends have been written in this file. Not yet tested.

-Anant
