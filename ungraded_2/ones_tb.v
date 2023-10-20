`timescale 1ns / 1ps

module tb_count_ones;

    reg clk;
    reg reset;
    reg data_in;
    wire [3:0] ones_count;

    
    count_ones #(10) u1 (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .ones_count(ones_count)
    );

   
    always begin
        #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        
        clk = 0;
        reset = 1;
        data_in = 0;

        #10 reset = 0;  

        // Apply input data
        #10 data_in = 1;   
        #10 data_in = 0;  
        #10 data_in = 1;   
        #10 data_in = 0;   
        #10 data_in = 0;
        #10 data_in = 1;
        #10 data_in = 1;
        #10 data_in = 0;
        #10 data_in = 0;
        #10 begin 
            data_in = 1;    
            $display("Number of '1's in the last 10 bits: %d", ones_count);
        end

        #10 $finish;     
    end

endmodule
