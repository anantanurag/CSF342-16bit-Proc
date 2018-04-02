//Vima Gupta - 2014A3PS246P
//Akshay Gattani - 2014A3PS190P
//Amitsinh Kokate - 2012A8PS350P




`timescale 1ns / 1ps  

//instruction memory
module ins_mem(instruction,pc);

output [15:0]instruction;
input [15:0] pc;
integer i;



reg [15:0] ins_memory [0:512]; //confirmed

//create text file ins_mem.txt in the same folder with 256 rows each with a 4 digit hexadecimal number.


initial begin
	 
           for(i=34;i<512;i=i+1)  
                ins_memory[i] <= 16'hf767;  
	
      end
initial 
	begin
//xor
	ins_memory[0] = 16'h8101;
	ins_memory[2] = 16'hf717;
	ins_memory[4] = 16'h8300;
	ins_memory[6] = 16'hf737;
	ins_memory[8] = 16'h2013;
	ins_memory[10] = 16'h2410;
	ins_memory[12] = 16'h2530;
	ins_memory[14] = 16'h2645;
	ins_memory[16] = 16'h1413;
	ins_memory[18] = 16'hf747;
//mem_swap
	ins_memory[20] = 16'h9013;
	ins_memory[22] = 16'h8501;
	ins_memory[24] = 16'hf757;
	ins_memory[26] = 16'h9001;
	ins_memory[28] = 16'h8200;
	ins_memory[30] = 16'hf727;
	ins_memory[32] = 16'h1652;	

	/*ins_memory[20] = 16'h9013;
	ins_memory[22] = 16'h9001;
	ins_memory[24] = 16'h8101;
	ins_memory[26] = 16'hf717;
	ins_memory[28] = 16'h8300;
	ins_memory[30] = 16'hf737;
	ins_memory[32] = 16'h1413;
	ins_memory[34] = 16'hf747;*/
	
	/*ins_memory[8] = 16'h8300;
	ins_memory[10] = 16'hf737;
	ins_memory[4] = 16'hf717; 
	ins_memory[6] = 16'hf717; 
	ins_memory[8] = 16'h8300;
	ins_memory[10] = 16'h8300;	
	ins_memory[12] = 16'hf737;
	ins_memory[14] = 16'hf737;
	ins_memory[16] = 16'hf737; 
	ins_memory[18] = 16'h2013;
	ins_memory[20] = 16'h2410;
	ins_memory[22] = 16'h2530;
	ins_memory[24] = 16'h2645;//r6 has answer
	ins_memory[8] = 16'h2410;
	ins_memory[10] = 16'h2530;
	ins_memory[12] = 16'h2645;*/
	end

assign instruction = (pc[15:0] < 512 )? ins_memory[pc]: 16'd0;  
endmodule


//data memory
//data memory
module data_mem(dout,din,addr,mem_read,mem_write,clk);

output reg [15:0]dout;
input [15:0] din;
input [15:0] addr;
input mem_read,mem_write,clk;
integer i;

reg [15:0] data_memory [0:255]; //confirmed

//create text file dat_mem.txt in the same folder with 256 rows each with a 4 digit hexadecimal number.

initial begin  
           for(i=2;i<256;i=i+1)  
                data_memory[i] <= 16'hbbbb;  
      end  

initial 
	begin
	data_memory[0] = 16'h8100;
	data_memory[1] = 16'haaaa;
	/*data_memory[1] = 16'haaaa;
	data_memory[2] = 16'haaaa;
	data_memory[3] = 16'haaaa;
	data_memory[4] = 16'haaaa;
	data_memory[5] = 16'haaaa;
	data_memory[6] = 16'haaaa;
	data_memory[7] = 16'haaaa;
	data_memory[8] = 16'haaaa;*/
	end
	

always @ (*)
begin if (mem_read) 
dout <= data_memory[addr];
else dout <= 16'd0;
end

always @ (*)
begin if (mem_write)
data_memory[addr] <= din;
end

endmodule

//register file

module rf16(rdo1,rdo2,rdo3,rdin1,rdin2,wrin1,wrdata,wren,clk,rst);

output [15:0] rdo1,rdo2,rdo3;
input [3:0] rdin1,rdin2,wrin1;
input [15:0] wrdata;
input ren,wren,clk,rst;

reg [15:0] rf_random [0:15];

always @ (negedge clk or posedge rst )
begin
	if(rst) 
		begin
			rf_random[4'b0000] <= 16'h0000;
			rf_random[4'b0001] <= 16'h0000;
			rf_random[4'b0010] <= 16'h000f;
			rf_random[4'b0011] <= 16'h0001;
			rf_random[4'b0100] <= 16'h008f;
			rf_random[4'b0101] <= 16'h00f0;
			rf_random[4'b0110] <= 16'h0f80;
			rf_random[4'b0111] <= 16'hf00f;
			rf_random[4'b1000] <= 16'hfff0;
			rf_random[4'b1001] <= 16'h08ff;
			rf_random[4'b1010] <= 16'hf088;
			rf_random[4'b1011] <= 16'h8888;
			rf_random[4'b1100] <= 16'hffff;
			rf_random[4'b1101] <= 16'h0010;
			rf_random[4'b1110] <= 16'h81ff;
			rf_random[4'b1111] <= 16'h1fff;
		end
	else if(wren) rf_random[wrin1] <= wrdata;
end

initial 
	begin
			rf_random[4'b0000] <= 16'h0000;
			rf_random[4'b0001] <= 16'h0000;
			rf_random[4'b0010] <= 16'h000f;
			rf_random[4'b0011] <= 16'h0001;
			rf_random[4'b0100] <= 16'h008f;
			rf_random[4'b0101] <= 16'h00f0;
			rf_random[4'b0110] <= 16'h0f80;
			rf_random[4'b0111] <= 16'hf00f;
			rf_random[4'b1000] <= 16'hfff0;
			rf_random[4'b1001] <= 16'h08ff;
			rf_random[4'b1010] <= 16'hf088;
			rf_random[4'b1011] <= 16'h8888;
			rf_random[4'b1100] <= 16'hffff;
			rf_random[4'b1101] <= 16'h0010;
			rf_random[4'b1110] <= 16'h81ff;
			rf_random[4'b1111] <= 16'h1fff;
	end


assign rdo1 = rf_random[rdin1];
assign rdo2 = rf_random[rdin2];
assign rdo3 = rf_random[wrin1];

endmodule
  


//Arithmetic Logical Unit

module alu(aluout,flag,a,b,shamt,aluctrl);//should we write signed or not?

output reg [15:0] aluout;
output reg [3:0] flag;
input [15:0] a,b;
input [3:0] aluctrl;
input [3:0] shamt;
reg o,z,s,c,c1,ct;
reg [14:0] temp;

always@(a,b,aluctrl)//assignment?
begin
case(aluctrl)
    4'b0000 : begin {c,aluout} =  a+b;//ADD
                    {c1,temp} = a[14:0]+b[14:0];
                    o = (c^c1);
                    z = (aluout==0);
                    s = aluout[15];
                end
    4'b0001 : begin {c,aluout} =  a-b;//SUB
                    {c1,temp} = a[14:0]+b[14:0];
                    o = (c^c1);
                    z = (aluout==0);
                    s = aluout[15];
                end
    4'b0010 : begin {ct,aluout} =  ~(a&b);//NAND
                    c = 0;
                    o = 0;
                    z = (aluout==0);
                    s = aluout[15];
                end
    4'b0011 : begin {ct,aluout} = (~a)+1;//NEG
                    c = 0;
                    {c1,temp} = a[14:0]+b[14:0];
                    o = (ct^c1);
                    z = (aluout==0);
                    s = aluout[15];
                end
    4'b0100 : begin aluout = a>>>shamt;//SAR
                    s = aluout[15];
                    z = (aluout==0);
                    if (shamt==4'b0001) o = 0;
                    c = a[shamt-1];
                end
    4'b0101 : begin aluout = a>>shamt;//SHR
                    s = aluout[15];
                    z = (aluout==0);
                    if (shamt==4'b0001) o = aluout[15];
                    c = a[shamt-1];
                end
    4'b0110 : begin aluout = a<<shamt;//SHL
                    s = aluout[15];
                    z = (aluout==0);
                    c = aluout[15];
                    if(shamt==0) o = 0;
                end
    4'b0111 : begin aluout = a>>shamt|a<<(16-shamt);
                z = (aluout==0);
                end
    4'b1000 : begin aluout = a<<shamt|a>>(16-shamt);
                z = (aluout==0);
                end
    4'b1111 : begin aluout = a+0;
                z = (aluout==0);
                end

    default : begin aluout =16'd0;//check
                    {c,z,o,s} = 4'bzzzz;
                end
endcase
end

always @ (*)
flag = {o,z,s,c};
endmodule

//controller

`timescale 1ns / 1ps
 module control(opcode,func_code,reset,reg_src,mem_to_reg,jump,branch,mem_read,mem_write,reg_write,alu_ctrl,sign);
 output reg reg_src,mem_to_reg,jump,branch,mem_read,mem_write,reg_write,sign;
 output reg [3:0] alu_ctrl;
 input [3:0] opcode,func_code;
 input reset;
 always @(*)  
 begin  
      if(reset == 1'b1) begin  
                reg_src = 1'b0;  
                mem_to_reg = 1'b0;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                reg_write = 1'b0;
                alu_ctrl = 4'b0000;
                sign = 0;
      end  
      else begin  
      case(opcode)   
      4'b0000: begin // add  
                reg_src = 1'b0;  
                mem_to_reg = 1'b0;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                reg_write = 1'b1;  
                alu_ctrl = 4'b0000;
                sign = 0;
                end  
      4'b0001: begin // sub  
                reg_src = 1'b0;  
                mem_to_reg = 1'b0;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                reg_write = 1'b1;
                alu_ctrl = 4'b0001;
                sign = 0;
                end  
      4'b0010: begin // nand  
                reg_src = 1'b0;  
                mem_to_reg = 1'b0;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                reg_write = 1'b1; 
                alu_ctrl = 4'b0010;
                sign = 0;
                end  
      4'b0011: begin  
                mem_to_reg = 1'b0;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                reg_write = 1'b1;
                sign = 0;
                case(func_code)   
                4'b0000: begin // neg  
                          reg_src = 1'b0;
                          alu_ctrl = 4'b0011;
                          end
                4'b0001: begin // SAL  
                          reg_src = 1'b1;
                          alu_ctrl = 4'b0100;
                          end
                4'b0010: begin // SHR  
                          reg_src = 1'b1;
                          alu_ctrl = 4'b0101;
                          end
                4'b0011: begin // SHL  
                          reg_src = 1'b1;
                          alu_ctrl = 4'b0110;
                          end
                4'b0100: begin // RR  
                          reg_src = 1'b1;
                          alu_ctrl = 4'b0111;
                          end
                4'b0101: begin // RL  
                          reg_src = 1'b1;
                          alu_ctrl = 4'b1000;
                          end
                default: begin  
                          reg_src = 1'b0;  
                          alu_ctrl = 4'b0000;
                          end
                endcase
                end  
      4'b1000: begin // lw  
                reg_src = 1'bX;  
                mem_to_reg = 1'b1;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b1;  
                mem_write = 1'b0;  
                reg_write = 1'b1;
                alu_ctrl = 4'b0000;
                sign = 1;
                end  
      4'b1001: begin // sw  
                reg_src = 1'bX;  
                mem_to_reg = 1'bX;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b1;  
                reg_write = 1'b0;  
                alu_ctrl = 4'b0000;
                sign = 0;
                end  
      4'b1100: begin // jmp
                reg_src = 1'bX;  
                mem_to_reg = 1'bX;  
                jump = 1'b1;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                reg_write = 1'b0;  
                alu_ctrl = 4'b0000;
                sign = 0;
                end  
      4'b1101: begin // beq  
                reg_src = 1'b0;  
                mem_to_reg = 1'bX;  
                jump = 1'b0;  
                branch = 1'b1;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                reg_write = 1'b0;
                alu_ctrl = 4'b0001;
                sign = 0;
                end
	  
      default: begin  
                reg_src = 1'b0;  
                mem_to_reg = 1'b0;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                reg_write = 1'b1;
                alu_ctrl = 4'b1111;
                sign = 0;
                end  
      endcase  
      end  
 end  
 endmodule
  


//processor


 module processor(pc_out, alu_result,clk,reset);  
 output[15:0] pc_out, alu_result;
 input clk,reset;
 reg[15:0] pc_current;  
 wire signed[15:0] pc_next,pc2;  
 wire [15:0] instr;  
 wire jump,branch,mem_read,reg_src,mem_to_reg,mem_write,reg_write,sign;  
 wire     [3:0]     reg_write_dest;  
 wire     [15:0] reg_write_data;  
 wire     [3:0]     reg_read_addr_1;  
 wire     [15:0] reg_read_data_1;  
 wire     [3:0]     reg_read_addr_2;  
 wire     [15:0] reg_read_data_2;
 wire     [15:0] reg_read_data_3; 
 wire [15:0] sign_ext_im;  
 wire [3:0] alu_ctrl;  
 wire [15:0] ALU_out;  
 wire [3:0] flag;  
 wire signed[15:0] PC_j, PC_beq, PC_4beq;  
 wire beq_control;  
 wire [15:0]mem_read_data;  
 // PC
 

always @(posedge clk or posedge reset)  
 begin   
      if(reset)   
           pc_current <= 16'd0;  
      else  
           pc_current <= pc_next;  
 end  
 // PC + 2   
 assign pc2 = pc_current + 16'd2;  
 
// instruction memory  
 ins_mem instrucion_memory(.instruction(instr),.pc(pc_current));  
 
// control unit  
 control control_unit(.opcode(instr[15:12]),.func_code(instr[3:0]),.reset(reset),.reg_src(reg_src)  
                ,.mem_to_reg(mem_to_reg),.jump(jump),.branch(branch),.mem_read(mem_read),  
                .mem_write(mem_write),.reg_write(reg_write),.sign(sign),.alu_ctrl(alu_ctrl));  
 
// multiplexer regdest  
 assign reg_write_dest = instr[11:8];  
 // register file  
 
assign reg_read_addr_1 = (reg_src==1'b0) ? instr[7:4] : instr[11:8];  
assign reg_read_addr_2 = instr[3:0];  
 rf16 reg_file(.rdo1(reg_read_data_1),.rdo2(reg_read_data_2),.rdo3(reg_read_data_3),.rdin1(reg_read_addr_1),.rdin2(reg_read_addr_2),.wrin1(reg_write_dest),.wrdata(reg_write_data),.wren(reg_write),.clk(clk),.rst(reset)); 



 // sign extend  
 assign sign_ext_im = (sign==1'b0) ? {{9{instr[11]}},instr[10:4]} : {{9{instr[7]}},instr[6:0]};  
 
  
 // ALU   
 alu alu_unit(.aluout(ALU_out),.flag(flag),.a(reg_read_data_1),.b(reg_read_data_2),.shamt(instr[7:4]),.aluctrl(alu_ctrl));  
 

 // beq control  
 assign beq_control = branch & flag[2]; 
 
 // PC_beq  
 assign PC_beq = reg_read_data_3;
 assign PC_4beq = (beq_control==1'b1) ? PC_beq : pc2;  
 
// PC_j  
 assign PC_j = sign_ext_im;  

 // PC_next  
 assign pc_next = (jump==1'b1) ? PC_j : PC_4beq;  
 
// data memory  
 data_mem datamem(.dout(mem_read_data),.din(reg_read_data_2),.addr(sign_ext_im),.mem_read(mem_read),.mem_write(mem_write),.clk(clk));
 
// write back  
 assign reg_write_data = (mem_to_reg == 1'b1) ? mem_read_data : ALU_out;  
 // output  
 assign pc_out = pc_current;  
 assign alu_result = ALU_out;  
 endmodule 

`timescale 1ns/10ps

module tb_processor();

reg clk, reset;
wire [15:0] pc_out,alu_result;

//clock generator T = 100ns
initial 
begin
#0 clk = 1'b1;
forever #5000 clk = ~clk;
end

initial 
	begin
	#00 reset = 1'b1;
	#50 reset = 1'b0;
end


initial begin
 $monitor("t=%6d pc_out = %16b alu_result = %16b ",$time, pc_out, alu_result);
end

initial
begin
$dumpfile("processor.vcd");
$dumpvars ;
end


initial #500000 $stop;
processor uut (pc_out, alu_result,clk,reset);
endmodule

module stack(data_out,Full,Empty,Err,data_in,Pop,Push,clk,Reset);

output reg [15:0] data_out;
output reg Full,Empty,Err;
input [15:0] data_in;
input Pop,Push,clk,Reset;

reg [2:0] SP;
reg [15:0] Stack [0:7];

always @(posedge clk)
begin
    if (Reset==1)
    begin
        data_out = 16'bzzzzzzzzzzzzzzzz;
        SP = 3'b000;
        Full = 0;
        Empty = 0;  
        Err = 0; 
    end 
    if (Push==1)
    begin     
        if (Empty==1)
        begin
            Stack[SP] = data_in; 
            Empty = 0;
            if (Err==1) 
                Err=0;
        end
        else   
        if(Full==1)
        begin
            Stack[SP] = data_in;
            Err = 1; 
        end
        else
        begin
            SP = SP +1;
            Stack [SP] = data_in;
            if (SP == 3'b111)
            Full = 1;
        end
    end 
    if(Pop==1)
    begin 
        if ((SP == 3'b000) && (Empty!=1))
        begin   
            data_out = Stack[SP];
            Empty = 1;   
        end
        else if(Empty==1)
        begin 
            data_out = Stack[SP];
            Err = 1;
        end
        else
        begin 
            data_out = Stack[SP];
            if (SP != 3'b000)
            SP = SP-1;       
            if (Err==1)  Err = 0;
            if (Full==1) Full = 0;
        end
    end 
end
endmodule