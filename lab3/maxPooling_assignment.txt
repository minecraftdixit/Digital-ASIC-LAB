`timescale 1ns / 1ps

module maxPooling(
    input clk,
    input [21:0] input1,
    input [21:0] input2,
    input [21:0] input3,
    input [21:0] input4,
    input [21:0] input5,
    input [21:0] input6,
    input [21:0] input7,
    input [21:0] input8,
    input [21:0] input9,
    input [21:0] input10,
    input [21:0] input11,
    input [21:0] input12,
    input [21:0] input13,
    input [21:0] input14,
    input [21:0] input15,
    input [21:0] input16,
    input enable,
    output reg signed [21:0] output1,
    output reg maxPoolingDone
);

     
    reg [21:0] maxVal;
    reg [21:0] array_image [0:15];
    integer i ;

    always @ (posedge clk) begin
        if (enable) begin
            maxVal <= input1;
            maxPoolingDone <= 0;
            array_image[0] <= input1;
            array_image[1] <= input2;
            array_image[2] <= input3;
            array_image[3] <= input4;
            array_image[4] <= input5;
            array_image[5] <= input6;
            array_image[6] <= input7;
            array_image[7] <= input8;
            array_image[8] <= input9;
            array_image[9] <= input10;
            array_image[10] <= input11;
            array_image[11] <= input12;
            array_image[12] <= input13;
            array_image[13] <= input14;
            array_image[14] <= input15;
            array_image[15] <= input16;

            for ( i = 1; i <= 16; i = i + 1) begin
                if ($signed(maxVal) < $signed(array_image[i])) begin
                    maxVal <= array_image[i];
                end
            end

            output1 <= maxVal;
            maxPoolingDone <= 1;
        end
        else begin
            output1 <= 0;
            maxPoolingDone <= 0;
        end
    end

endmodule
----------------------------------------------------------------------------------------------------------
`timescale 1ns / 1ps

module maxPooling_tb;

	// Inputs
	reg [21:0] input1;
	reg [21:0] input2;
	reg [21:0] input3;
	reg [21:0] input4;
    reg [21:0] input1;
    reg [21:0] input2;
    reg [21:0] input3;
    reg [21:0] input4;
    reg [21:0] input5;
    reg [21:0] input6;
    reg [21:0] input7;
    reg [21:0] input8;
    reg [21:0] input9;
    reg [21:0] input10;
    reg [21:0] input11;
    reg [21:0] input12;
    reg [21:0] input13;
    reg [21:0] input14;
    reg [21:0] input15;
    reg [21:0] input16;
	reg clk;
	reg enable;

	// Outputs
	wire [21:0] output1;
	wire maxPoolingDone;
	
	reg [21:0] array_image [0:63];
	integer i = 0;

	// Instantiate the Unit Under Test (UUT)
	maxPooling uut (
.input1(input1),
.input2(input2),
.input3(input3),
.input4(input4),
.input5(input5),
.input6(input6),
.input7(input7),
.input8(input8),
.input9(input9),
.input10(input10),
.input11(input11),
.input12(input12),
.input13(input13),
.input14(input14),
.input15(input15),
.input16(input16),

		.clk(clk), 
		.enable(enable), 
		.output1(output1), 
		.maxPoolingDone(maxPoolingDone)
	);
	
	initial begin
		// Initialize Inputs
          input1 = 0;
          input2 = 0;
          input3 = 0;
          input4 = 0;
          input5 = 0;
          input6 = 0;
          input7 = 0;
          input8 = 0;
          input9 = 0;
          input10 = 0;
          input11 = 0;
          input12 = 0;
          input13 = 0;
          input14 = 0;
          input15 = 0;
          input16 = 0;

		array_image[0] = 22'b1110000000000011001000;
		array_image[1] = 22'b1111111111111111100100;
		array_image[2] = 22'b1111111111111110011100;
		array_image[3] = 22'b1111111111111100111000;
		array_image[4] = 22'b0000000000000001100100;
		array_image[5] = 22'b0000000000000100101100;
		array_image[6] = 22'b0000000000000011001000;
		array_image[7] = 22'b1111111111111110011100;
		array_image[8] = 22'b0000000000000001100100;
		array_image[9] = 22'b0000000000000100101100;
		array_image[10] = 22'b0000000000001010111100;
		array_image[11] = 22'b1111111111111011010100;
		array_image[12] = 22'b0000000000000000000111;
		array_image[13] = 22'b1111111111111111111101;
		array_image[14] = 22'b0000000000000000001000;
		array_image[15] = 22'b0000000000000000001111;
                array_image[16] = 22'b0011001001110001001111;  
                array_image[17] = 22'b1111110111001100111101;  
                array_image[18] = 22'b0111110110001000111100;  
                array_image[19] = 22'b1001000011111111011000;  
                array_image[20] = 22'b0011011001000100101111;  
                array_image[21] = 22'b0111101011111110100001; 
                array_image[22] = 22'b1010111001001001111001; 
                array_image[23] = 22'b1000111000111011100111; 
                array_image[24] = 22'b1111100111010100001111; 
                array_image[25] = 22'b1010100110000001100010;  
                array_image[26] = 22'b1010101001101011011100;  
                array_image[27] = 22'b0101000101000000010100; 
                array_image[28] = 22'b0011101010011110110010; 
                array_image[29] = 22'b0011101010011110110010;  
                array_image[30] = 22'b1110100000011010000110;  
                array_image[31] = 22'b1110100000011010000111;   
                array_image[32] = 22'b0011101010010010010000; 
                array_image[33] = 22'b1111100101101000111101;  
                array_image[34] = 22'b1111110110101001001101;  
                array_image[35] = 22'b1010010000100000111010;  
                array_image[36] = 22'b0100001000101001001011;  
                array_image[37] = 22'b0100111001110001111011; 
                array_image[38] = 22'b0110101000000000001001;  
                array_image[39] = 22'b1000101000111100000001;  
                array_image[40] = 22'b1011000011101110100001; 
                array_image[41] = 22'b0101010110001110010110;  
                array_image[42] = 22'b1110011010011101010110;  
                array_image[43] = 22'b1010011111000111001001;  
                array_image[44] = 22'b0001100111001001110001; 
                array_image[45] = 22'b1101110101110110011100;  
                array_image[46] = 22'b1101111011001110011001;  
                array_image[47] = 22'b1001010101011100010110;  
                array_image[48] = 22'b0011100000101110111110;  
                array_image[49] = 22'b0011110011010111110111;  
                array_image[50] = 22'b1110010100010101101100;  
                array_image[51] = 22'b1001000000111001101111;  
                array_image[52] = 22'b0001111110101100111000;  
                array_image[53] = 22'b1111011101110111011110;  
                array_image[54] = 22'b0011000111100001110000;  
                array_image[55] = 22'b0011101101000011110010;  
                array_image[56] = 22'b1110111110010100010101;     
                array_image[57] = 22'b0100001000010110110011;   
                array_image[58] = 22'b0000010000110011001101;   
                array_image[59] = 22'b1101111101100000001011;  
                array_image[60] = 22'b1010110110000011101011;  
                array_image[61] = 22'b0111100111001101111011; 
                array_image[62] = 22'b0101110100111111101011;  
                array_image[63] = 22'b1000110000110010010100;  
                array_image[64] = 22'b0110010111100111001010;  

		enable = 0;
		clk = 0;
	end
	
	always #5 clk = ~clk;	
	
	always @ (posedge clk) begin
		if(i < 64) begin
			enable = 1;
			input1 = array_image[i];
			input2 = array_image[i+1];
			input3 = array_image[i+2];
			input4 = array_image[i+3];
                        input5 = array_image[i + 4];
                        input6 = array_image[i + 5];
                        input7 = array_image[i + 6];
                        input8 = array_image[i + 7];
                        input9 = array_image[i + 8];
                        input10 = array_image[i + 9];
                        input11 = array_image[i + 10];
                        input12 = array_image[i + 11];
                        input13 = array_image[i + 12];
                        input14 = array_image[i + 13];
                        input15 = array_image[i + 14];
                        input16 = array_image[i + 15];
		        i = i + 16;
		end
		else begin
			enable = 0;
		end
	end
      
endmodule














