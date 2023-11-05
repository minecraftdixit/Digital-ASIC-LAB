 `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ayush Dixit
// 
// Create Date:    05:46:39 22/10/2023 
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



module Matrix_operation #(parameter DATA_WIDTH = 1024, parameter MATRIX_SIZE = 8)(A, B, Mode, Result);

  input [DATA_WIDTH-1:0] A;
  input [DATA_WIDTH-1:0] B;
  input Mode;
  output [DATA_WIDTH-1:0] Result;

  reg [DATA_WIDTH-1:0] Result;
  reg [15:0] A1 [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];
  reg [15:0] B1 [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];
  reg [15:0] Res1 [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];

  integer i, j;

  always @ (A or B or Mode) begin
     {A1[0][0], A1[0][1], A1[0][2], A1[0][3], A1[0][4], A1[0][5], A1[0][6], A1[0][7], A1[0][8],
A1[1][0], A1[1][1], A1[1][2], A1[1][3], A1[1][4], A1[1][5], A1[1][6], A1[1][7], A1[1][8],
A1[2][0], A1[2][1], A1[2][2], A1[2][3], A1[2][4], A1[2][5], A1[2][6], A1[2][7], A1[2][8],
A1[3][0], A1[3][1], A1[3][2], A1[3][3], A1[3][4], A1[3][5], A1[3][6], A1[3][7], A1[3][8],
A1[4][0], A1[4][1], A1[4][2], A1[4][3], A1[4][4], A1[4][5], A1[4][6], A1[4][7], A1[4][8],
A1[5][0], A1[5][1], A1[5][2], A1[5][3], A1[5][4], A1[5][5], A1[5][6], A1[5][7], A1[5][8],
A1[6][0], A1[6][1], A1[6][2], A1[6][3], A1[6][4], A1[6][5], A1[6][6], A1[6][7], A1[6][8],
A1[7][0], A1[7][1], A1[7][2], A1[7][3], A1[7][4], A1[7][5], A1[7][6], A1[7][7]} = A;
     {B1[0][0], B1[0][1], B1[0][2], B1[0][3], B1[0][4], B1[0][5], B1[0][6], B1[0][7], B1[0][8],
B1[1][0], B1[1][1], B1[1][2], B1[1][3], B1[1][4], B1[1][5], B1[1][6], B1[1][7], B1[1][8],
B1[2][0], B1[2][1], B1[2][2], B1[2][3], B1[2][4], B1[2][5], B1[2][6], B1[2][7], B1[2][8],
B1[3][0], B1[3][1], B1[3][2], B1[3][3], B1[3][4], B1[3][5], B1[3][6], B1[3][7], B1[3][8],
B1[4][0], B1[4][1], B1[4][2], B1[4][3], B1[4][4], B1[4][5], B1[4][6], B1[4][7], B1[4][8],
B1[5][0], B1[5][1], B1[5][2], B1[5][3], B1[5][4], B1[5][5], B1[5][6], B1[5][7], B1[5][8],
B1[6][0], B1[6][1], B1[6][2], B1[6][3], B1[6][4], B1[6][5], B1[6][6], B1[6][7], B1[6][8],
B1[7][0], B1[7][1], B1[7][2], B1[7][3], B1[7][4], B1[7][5], B1[7][6], B1[7][7]} = B;
     {Res1[0][0], Res1[0][1], Res1[0][2], Res1[0][3], Res1[0][4], Res1[0][5], Res1[0][6], Res1[0][7], Res1[0][8],
Res1[1][0], Res1[1][1], Res1[1][2], Res1[1][3], Res1[1][4], Res1[1][5], Res1[1][6], Res1[1][7], Res1[1][8],
Res1[2][0], Res1[2][1], Res1[2][2], Res1[2][3], Res1[2][4], Res1[2][5], Res1[2][6], Res1[2][7], Res1[2][8],
Res1[3][0], Res1[3][1], Res1[3][2], Res1[3][3], Res1[3][4], Res1[3][5], Res1[3][6], Res1[3][7], Res1[3][8],
Res1[4][0], Res1[4][1], Res1[4][2], Res1[4][3], Res1[4][4], Res1[4][5], Res1[4][6], Res1[4][7], Res1[4][8],
Res1[5][0], Res1[5][1], Res1[5][2], Res1[5][3], Res1[5][4], Res1[5][5], Res1[5][6], Res1[5][7], Res1[5][8],
Res1[6][0], Res1[6][1], Res1[6][2], Res1[6][3], Res1[6][4], Res1[6][5], Res1[6][6], Res1[6][7], Res1[6][8],
Res1[7][0], Res1[7][1], Res1[7][2], Res1[7][3], Res1[7][4], Res1[7][5], Res1[7][6], Res1[7][7]} = {DATA_WIDTH{1'b0}};
  
     if (Mode == 0) begin // Add
        for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
          for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
            Res1[i][j] = A1[i][j] + B1[i][j];
          end
        end
     end
     else if (Mode == 1) begin  // Subtraction 
        for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
          for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
            Res1[i][j] = B1[i][j] - A1[i][j];
          end
        end
     end 

     Result = {Res1[0][0], Res1[0][1], Res1[0][2], Res1[0][3], Res1[0][4], Res1[0][5], Res1[0][6], Res1[0][7], Res1[0][8],
Res1[1][0], Res1[1][1], Res1[1][2], Res1[1][3], Res1[1][4], Res1[1][5], Res1[1][6], Res1[1][7], Res1[1][8],
Res1[2][0], Res1[2][1], Res1[2][2], Res1[2][3], Res1[2][4], Res1[2][5], Res1[2][6], Res1[2][7], Res1[2][8],
Res1[3][0], Res1[3][1], Res1[3][2], Res1[3][3], Res1[3][4], Res1[3][5], Res1[3][6], Res1[3][7], Res1[3][8],
Res1[4][0], Res1[4][1], Res1[4][2], Res1[4][3], Res1[4][4], Res1[4][5], Res1[4][6], Res1[4][7], Res1[4][8],
Res1[5][0], Res1[5][1], Res1[5][2], Res1[5][3], Res1[5][4], Res1[5][5], Res1[5][6], Res1[5][7], Res1[5][8],
Res1[6][0], Res1[6][1], Res1[6][2], Res1[6][3], Res1[6][4], Res1[6][5], Res1[6][6], Res1[6][7], Res1[6][8],
Res1[7][0], Res1[7][1], Res1[7][2], Res1[7][3], Res1[7][4], Res1[7][5], Res1[7][6], Res1[7][7]};
  end

endmodule
