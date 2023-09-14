`timescale 1ns / 1ps

module maxPooling_tb;

    // Inputs
    reg [21:0] input1;
    reg [21:0] input2;
    reg [21:0] input3;
    reg [21:0] input4;
    reg clk;
    reg enable;

    // Outputs
    wire [21:0] output1;
    wire maxPoolingDone;

    reg [21:0] array_image [0:15];
    integer i = 0;

    // Instantiate the Unit Under Test (UUT)
    maxPooling uut (
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .input4(input4),
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

        // Read input data from a text file
        $readmemb("sample.txt", array_image);

        enable = 0;
        clk = 0;
    end

    always #5 clk = ~clk;

    always @ (posedge clk) begin
        if (i < 16) begin
            enable = 1;
            input1 = array_image[i];
            input2 = array_image[i+1];
            input3 = array_image[i+2];
            input4 = array_image[i+3];
            i = i + 4;
            $display("Input1: %d, Input2: %d, Input3: %d, Input4: %d", input1, input2, input3, input4);
            
    $display("Output1: %d", output1);
        end
        else begin
            enable = 0;
        end
    end
 

endmodule
