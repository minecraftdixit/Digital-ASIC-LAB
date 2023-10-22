
module TopModule (
  input clk,
  input reset,
  input put1, put2,
  input get1, get2,
  input [WIDTH-1:0] data_in1, data_in2,
  output empty_bar1, empty_bar2,
  output full_bar1, full_bar2,
  output [WIDTH-1:0] data_out1, data_out2,
  output [WIDTH-1:0] sum
);

parameter DEPTH = 8;
parameter WIDTH = 16;
parameter POINTER_WIDTH = 3;

wire  empty_bar2, full_bar1, full_bar2;
wire [WIDTH-1:0]   data_out2;
 

FIFO fifo1 (
  .clk(clk),
  .reset(reset),
  .put(put1),
  .get(get1),
  .data_in(data_in1),
  .empty_bar(empty_bar1),
  .full_bar(full_bar1),
  .data_out(data_out1)
);

FIFO fifo2 (
  .clk(clk),
  .reset(reset),
  .put(put2),
  .get(get2),
  .data_in(data_in2),
  .empty_bar(empty_bar2),
  .full_bar(full_bar2),
  .data_out(data_out2)
);

Adder adder (
  .in1(data_out1),
  .in2(data_out2),
  .sum(sum)
);

endmodule
