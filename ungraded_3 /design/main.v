`timescale 1ns / 1ps
 
module Matrix_operation #(parameter DATA_WIDTH = 64, parameter MATRIX_SIZE = 2)(A, B,  Result);

input [DATA_WIDTH-1:0] A;
input [DATA_WIDTH-1:0] B;

output [DATA_WIDTH-1:0] Result;

reg [DATA_WIDTH-1:0] Result;
reg [15:0] A1 [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];
reg [15:0] B1 [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];
reg [15:0] Res1 [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];

integer i, j;

always @ (A or B ) begin
{A1[0][0], A1[0][1] ,
A1[1][0], A1[1][1]} = A;

{B1[0][0], B1[0][1],
B1[1][0], B1[1][1]} = B;

{Res1[0][0], Res1[0][1],
Res1[1][0], Res1[1][1]} = {DATA_WIDTH{1'b0}};

for (i = 0; i < MATRIX_SIZE; i = i + 1)
 begin
for (j = 0; j < MATRIX_SIZE; j = j + 1) 
begin
Res1[i][j] = A1[i][j] + B1[i][j];
end
end
 


Result = {Res1[0][0], Res1[0][1],
Res1[1][0], Res1[1][1]};
end

endmodule
