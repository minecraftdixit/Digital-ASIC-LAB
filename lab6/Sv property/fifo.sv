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
/////////////////////
 property count_non_negative;
  @(posedge clk) (reset == 0 && enable == 1) |-> (count >= 0);
endproperty

 property data_out_is_zero;
  @(posedge clk) disable iff (reset) (reset == 0 && enable == 1) |-> (count >= 0);
endproperty

 property push_and_pop;
 @(posedge clk) disable iff (reset) !(pop && push);
endproperty

 property overflow_prevention ;
  @(posedge  clk) disable iff (reset) (enable && push && !pop) |-> (count < size);
      endproperty
      
  property underflow_prevention ;
  @(posedge clk) disable iff (reset) ( enable && pop) |-> (count > 0);
      endproperty     
      
 property FIFO_is_empty_initially ;
   @(posedge clk) disable iff (reset) ( !$changed(enable) ) |-> ##1 (count == 0 && frontptr == rearptr) ;
      endproperty
      property   buffer_remains_unchanged;
   @(posedge clk) disable iff (reset) !enable |-> $stable(buffer) ;
endproperty      

property  No_count_change;
@(posedge clk) disable iff (reset) !enable |-> $stable(count)  ;
endproperty
////////////////////////////////////////////////////////////////////////////////////////////////Property

property fifo_empty;
  @(posedge clk) (reset == 0 && enable == 1) |-> (count1 == 0);
endproperty

property fifo_almost_full;
  @(posedge clk) (reset == 0 && enable == 1) |-> (count1 == size - 1);
endproperty

property data_out_matches_front;
  @(posedge clk) (reset == 0 && enable == 1 && pop == 1 && count1 > 0) |-> (data_out == buffer[frontptr]);
endproperty

property valid_data_out_after_push;
  @(posedge clk) (reset == 0 && enable == 1 && push == 1 && count1 < size - 1) |-> (data_out == buffer[frontptr]);
endproperty


//property  ;
//   @(posedge clk) disable iff (reset)  ;
//endproperty   
/////////////////////////////////////////////////////////////////////////////////////////////////////assert property
assert property (count_non_negative) else $display("Count is negative "); // It is always non-negative 
assert property (data_out_is_zero) else $display("Count is negative "); //Assertion to check that data_out is zero when the count is zero
assert property (push_and_pop) else $display("Push and Pop happening at same time  "); //    Assertion to check that pop and push are mutually exclusive
assert property (overflow_prevention) else $display("overflow happening"); //    Assertion to check that overflow happening 
assert property (underflow_prevention) else $display("underflow happening"); //    Assertion to check that underflow happening 
assert property (FIFO_is_empty_initially) else $display("FIFO_is_not empty_initially  "); //    Assertion to check that FIFO_is_empty_initially
assert property (buffer_remains_unchanged) else $display("   buffers is changed without enable "); //    Assertion to check that buffer_remains_unchanged
assert property(No_count_change)else $display(" count is changed even enable signal is low  "); //    Assertion to check that buffer_remains_unchanged
 


 
	
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

