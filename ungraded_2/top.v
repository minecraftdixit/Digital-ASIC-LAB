module top_module (
  input bit clk,
  input rst_n,
  input [9:0] data_in,
  input x , 
  output reg [4:0] ones_out,
  output z
);

 
  fsm sequence_detector (
    .clk(clk),
    .rst_n(rst_n),
    .x(x),  
    .z(z)
  );
 
  one counter (
    .A(data_in),
    .ones(ones_out)
  );
 
 

endmodule
