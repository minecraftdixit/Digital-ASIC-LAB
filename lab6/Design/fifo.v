`timescale 1us/1us

module fifo(data_in,data_out,pop,push,clk,reset,enable,count,frontdata,reardata);

input [31:0] data_in;
output [31:0] data_out; 
input clk,reset,enable,pop,push;
output [2:0] count;
output [31:0] frontdata,reardata;

reg data_out;
wire [31:0] data_in;
reg count;
reg [31:0] frontdata;
reg [31:0] reardata;
reg [3:0] count1;
reg [2:0] frontptr;
reg [2:0] rearptr;
reg [31:0] buffer [0:3];
parameter size = 4;

reg pop1;
reg push1;

initial begin
	count1 <= 0;
	frontptr <= 0;
	rearptr <= 0;	
end 


	
// ---------------------fifo-------------------------------------------

always @(posedge clk) begin

	if(reset == 1) begin

	count1 = 0;
	frontptr = 0;
	rearptr = 0;

	end

	else if(reset == 0 && enable == 0) begin
	
	count1 = count1;
	frontptr = frontptr;
	rearptr = rearptr;
	data_out = 32'b0;
	end
	
	else begin
			if(push == 1) begin
				if(count1 == 0) begin
				    if(data_in[31:30] == 2'b01) begin
					frontptr = 1;
					rearptr = 1;
					buffer[rearptr] = data_in;
					count1 = count1 + 1;
				    end
						
			 	end
				else if(count1 == 3'b100) begin
					frontptr = frontptr;
					rearptr = rearptr;
					count1 = count1;
					buffer[rearptr] = buffer[rearptr];		
				end
				else begin
					if(data_in[31:30] != 2'b00) begin
					rearptr = (rearptr + 1)%size;
					count1 = count1 + 1;
					buffer[rearptr] = data_in;
					end
					
					
				end
		
			end
		
			if(pop == 1) begin
			
				if(count1 == 0) begin
				 	frontptr = 0;
					rearptr = 0;
					count1 = 0;
					data_out = 32'b0;
				end
				else if(count1 == 1) begin
					data_out = buffer[frontptr];
					frontptr = 0;
					rearptr = 0;
					count1 = count1 - 1;
					
				end 
				else begin
					data_out = buffer[frontptr];
					frontptr = (frontptr + 1)%size;
					count1 = count1 - 1;
				end
			end
				
					
	end //else loop	
	
	count = count1; 
	reardata = buffer[rearptr];
	frontdata = buffer[frontptr];
	if(count1 == 0) begin
	reardata = 32'b0;
	frontdata = 32'b0;
	
	end
	 

end //always loop


endmodule
