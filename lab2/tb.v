module testbench;
  
    reg clk;
    reg reset;
    reg [7:0] input1;
    reg [7:0] input2;
    wire [7:0] sum_out;
    wire done;

  
    top_module dut (
        .clk(clk),
        .reset(reset),
        .input1(input1),
        .input2(input2),
        .sum_out(sum_out),
        .done(done)
    );

 
    always  #10  clk = ~clk;
   

    // Stimulus generation
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        input1 = 8'h00;
        input2 = 8'h00;

        // Reset
        #5 reset = 1;
 
        #5 input1 = 8'h10;
        #5 input2 = 8'h20;
        #5 reset = 1;
         #5 input1 = 8'h30;
        #5 input2 = 8'h40;

        
        wait(done);

        // Print results
        $display("sum_out = %h", sum_out);
        $finish;
    end

endmodule
