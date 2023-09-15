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

      $readmemb("sample2.txt", array_image);
               

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
            input5 = array_image[i+4];
             input6 = array_image[i+5];
              input7 = array_image[i+6];
               input8 = array_image[i+7];
              input9 = array_image[i+8];
                input10 = array_image[i+9];
               input11 = array_image[i+10];
               input12 = array_image[i+11];
                input13 = array_image[i+12];
               input14 = array_image[i+13];
                input15 = array_image[i+14];
                input16 = array_image[i+15];
		        i = i + 16;
		        enable= 1;
		         #30;
		end
		else begin
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
		if (maxPoolingDone) begin
			enable = 0;
			#500;
			$finish ;
		end
	end
     end 
endmodule














