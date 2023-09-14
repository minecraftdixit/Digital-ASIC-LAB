module adder_unit(
    input wire clk,
    input wire start,
    input wire [7:0] input1,
    input wire [7:0] input2,
    output wire [7:0] sum,
    output wire done
);

    reg [7:0] sum_reg;
    reg [3:0] state;  

    always @(posedge clk) begin
        case (state)
            4'b0000: begin // Idle state
                if (start) begin
                    sum_reg <= input1 + input2;
                    state <= 4'b0001; 
                end
            end
            4'b0001: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
              4'b0010: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
              4'b0011: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
              4'b0100: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
              4'b0101: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
              4'b0110: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
              4'b0111: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
              4'b1000: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
              4'b1001: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
             4'b1010: begin // Processing states
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= state + 1; // Move to the next processing state
            end
            4'b1011: begin // Final processing state
                sum_reg <= sum_reg; // Keep sum_reg unchanged during processing
                state <= 4'b1100; // Move to the output state
            end
            4'b1100: begin // Output state
                state <= 4'b0000; // Return to the idle state
            end
            default: begin // Other states
                state <= 4'b0000; // Return to the idle state
            end
        endcase
    end

    assign sum = sum_reg;
    assign done = (state == 4'b1100);

endmodule