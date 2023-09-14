module top_module(
    input wire clk,
    input wire reset,
    input wire [7:0] input1,
    input wire [7:0] input2,
    output wire [7:0] sum_out,
    output wire done
);

    wire [7:0] sum[0:399];
    wire done_array[0:399];
    wire start[0:4];  

    assign done = done_array[399];
    assign sum_out = sum[399];

    adder_unit adder_inst0 (
        .clk(clk),
        .start(reset),
        .input1(input1),
        .input2(input2),
        .sum(sum[0]),
        .done(done_array[0])
    );
generate
    // Instantiate five adder units
    for (genvar i = 0; i < 5; i = i + 1) begin : gen_adders
        if (i == 0) begin
            assign start[i] = reset; // For the first adder, use reset signal
        end else begin
            assign start[i] = done_array[(i-1) * 80]; // For others, use done_array
        end
        
        adder_unit add (
            .clk(clk),
            .start(start[i]),
            .input1(input1),  
            .input2(input2), 
            .sum(sum[i * 80]),
            .done(done_array[i * 80])
        );
    end
endgenerate
endmodule