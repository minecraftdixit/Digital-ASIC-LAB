module count_ones #(parameter WIDTH = 10)
(
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [3:0] ones_count
);

reg [WIDTH-1:0] shift_reg;
integer i;
integer count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 0;
        ones_count <= 0;
    end else begin
        shift_reg <= {shift_reg[WIDTH-2:0], data_in};
        
        count = 0;
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (shift_reg[i])
                count = count + 1;
        end
        
        ones_count <= count;
    end
end

endmodule
