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

    reg [21:0] maxVal= 22'b1000000000000000000000;
    reg [21:0] array_image [0:15];
    integer i;

    always @ (posedge clk) begin
        if (enable) begin
             
            maxPoolingDone = 0;
            array_image[0] = input1;
            array_image[1] = input2;
            array_image[2] = input3;
            array_image[3] = input4;
            array_image[4] = input5;
            array_image[5] = input6;
            array_image[6] = input7;
            array_image[7] = input8;
            array_image[8] = input9;
            array_image[9] = input10;
            array_image[10] = input11;
            array_image[11] = input12;
            array_image[12] = input13;
            array_image[13] = input14;
            array_image[14] = input15;
            array_image[15] = input16;

            for (i = 0; i < 16; i = i + 1) begin
                if ($signed(maxVal) < $signed(array_image[i])) begin
                    maxVal = array_image[i];
                end
            end
            
            output1 = maxVal;
            maxPoolingDone = 1;
        end
        else begin
        maxVal = 0;
            
            maxPoolingDone = 0;
            output1 = 0;
            maxPoolingDone = 0;
        end
    end
endmodule
