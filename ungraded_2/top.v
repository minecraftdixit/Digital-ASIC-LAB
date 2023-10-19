`timescale 1ns / 1ps

module top_module(
    input wire clk,             // Clock input
    input wire rst,             // Reset input
    input wire data_in,         // Input data stream
    output wire [3:0] count_out, // Output count every 10 bits
    output wire detect_out      // Output signal when sequence detected
);

wire sequence_detected; // Wire to carry the detection flag

// Instantiate the ones-Counter module
ones_counter ones_counter_inst (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .count_out(count_out)
);

// Instantiate the sequence detector FSM
sequence_detector sequence_detector_inst (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .detect_out(sequence_detected)
);

// Output the detection flag from the sequence detector
assign detect_out = sequence_detected;

endmodule
