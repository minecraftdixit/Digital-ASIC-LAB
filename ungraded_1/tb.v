`timescale 1ns / 1ps

module testbench;

  reg enable;
  reg [3:0] addr;
  reg [31:0] Data_in;
  wire [31:0] Data_out;
  
   
  new uut (
    .enable(enable),
    .addr(addr),
    .Data_in(Data_in),
    .Data_out(Data_out)
  );
 
  initial begin
  
    enable = 0;
    addr = 0;
    Data_in = 32'hAABBCCDD;

    
    enable = 0;
    addr = 5;  
    #10;
    $display("Test Case 1: Data_out = %h", Data_out);

    
    enable = 1;
    addr = 3;  
    Data_in = 32'h12345678;  
    #10;
    $display("Test Case 2: Data_in = %h", Data_in);
    
   
    enable = 0;
    addr = 3;  
    #10;
    $display("Test Case 3: Data_out = %h", Data_out);

    $finish;
  end

endmodule
