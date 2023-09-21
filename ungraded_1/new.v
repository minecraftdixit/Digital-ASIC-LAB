`timescale 1ns / 1ps

module new (
  input enable,
  input [3:0] addr,
  input [31:0] Data_in,
  output [31:0] Data_out
);

  reg [31:0] mem [9:0];
  reg [31:0] Data_out_reg; 
  integer i;

  always @(*) begin
    if (enable) begin
       
      for (i = 0; i < 10; i = i + 1) begin
        if (i == addr)
          mem[i] <= Data_in;
      end
      Data_out_reg <= 32'b0;  
    end else begin
       
      Data_out_reg <= mem[addr];
    end
  end

assign Data_out =  Data_out_reg ;

endmodule
