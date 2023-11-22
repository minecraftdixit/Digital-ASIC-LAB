 `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ayush Dixit
// 
// Create Date:    05:46:39 22/11/2023 
// Design Name: 
// Module Name:    Matrix_operation 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Matrix_operation #(parameter DATA_WIDTH = 192, parameter MATRIX_SIZE_A = 4, parameter MATRIX_SIZE_B = 3)(A, B, Result, Sum);

input [DATA_WIDTH-1:0] A;
input [DATA_WIDTH-1:0] B;

output [DATA_WIDTH-1:0] Result;
output reg [DATA_WIDTH-1:0] Sum;
reg [DATA_WIDTH-1:0] Result;
reg [15:0] A1[0:MATRIX_SIZE_A-1][0:MATRIX_SIZE_B-1];
reg [15:0] B1[0:MATRIX_SIZE_B-1][0:MATRIX_SIZE_A-1];
reg [12:0] Res1[0:MATRIX_SIZE_A-1][0:MATRIX_SIZE_A-1];

integer i, j, k;

always @ (A or B) begin
    {A1[0][0], A1[0][1], A1[0][2], A1[1][0], A1[1][1], A1[1][2], A1[2][0], A1[2][1], A1[2][2], A1[3][0], A1[3][1], A1[3][2]} = A;
    {B1[0][0], B1[0][1], B1[0][2], B1[0][3], B1[1][0], B1[1][1], B1[1][2], B1[1][3], B1[2][0], B1[2][1], B1[2][2], B1[2][3]} = B;

    {Res1[0][0], Res1[0][1], Res1[0][2],Res1[0][3], Res1[1][0], Res1[1][1], Res1[1][2], Res1[1][3],Res1[2][0], Res1[2][1], Res1[2][2],Res1[2][3], Res1[3][0], Res1[3][1], Res1[3][2],Res1[3][3]} = {DATA_WIDTH{1'b0}};

    for (i = 0; i < MATRIX_SIZE_A; i = i + 1) begin
        for (j = 0; j < MATRIX_SIZE_A; j = j + 1) begin
         //   Res1[i][j] = 0;
            for (k = 0; k < MATRIX_SIZE_B; k = k + 1) begin
                Res1[i][j] = Res1[i][j] + A1[i][k] * B1[k][j];
            end
        end
    end

Result = {Res1[0][0], Res1[0][1], Res1[0][2], Res1[0][3], Res1[1][0], Res1[1][1], Res1[1][2], Res1[1][3], Res1[2][0], Res1[2][1], Res1[2][2], Res1[2][3], Res1[3][0], Res1[3][1], Res1[3][2], Res1[3][3]};
Sum = Res1[0][0] + Res1[0][1] + Res1[0][2] + Res1[0][3] + Res1[1][0] + Res1[1][1] + Res1[1][2] + Res1[1][3] + Res1[2][0] + Res1[2][1] + Res1[2][2] + Res1[2][3] + Res1[3][0] + Res1[3][1] + Res1[3][2] + Res1[3][3];
end

endmodule




 
