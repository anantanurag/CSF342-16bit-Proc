`include "programCounter.v"
`include "MemoryDataRegister.v"
`include "dataMemory.v"
`include "instructionMemory.v"
`include "alu.v"
`include "instructionRegister.v"
`include "MUXpreALU.v"
`include "registerFile.v"
`include "controllerFSM.v"


module TOP(clk, rst);

input wire clk, rst;



controllerFSM FSM_Main();

programCounter PC();

instructionMemory IM();
instructionRegister IR();

dataMemory DM();
MemoryDataRegister MDR();

registerFile RF();

alu ALU_MAIN();
MUXpreALU MPA();


endmodule