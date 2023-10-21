`timescale 1ns / 1ps
 
module top_module_tb;
  reg clk;
  reg rst_n;
  reg x ; 
  reg [9:0] data_in;
  wire [4:0] ones_out;
  wire z;
 
  top_module uut (
    .clk(clk),
    .rst_n(rst_n),
    .x(x), 
    .data_in(data_in),
    .ones_out(ones_out),
    .z(z)
  );
 
  always begin
    #2 clk = ~clk;
  end

  initial begin
    x = 0;
    #1 rst_n = 0;
    #2 rst_n = 1;
    
    clk = 0;
   
    data_in = 10'b1010101010;
    #20 data_in = 10'b1100110011;  
    #20 data_in = 10'b0010101010; 
    #20 data_in = 10'b1010101011; 
    #20 data_in = 10'b0010101010; 
    #20 data_in = 10'b1010101011; 
  
    
    #4 x = 1;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 0;
    #10;
  end
   always @(posedge clk)  
   begin
      $monitor("///ONES/////data_in = %b, ones_out = %d", data_in, ones_out );
     $monitor("//FSM/////%0t: input = %0b, detected = %0b", $time, x, z);
    
  end

endmodule
