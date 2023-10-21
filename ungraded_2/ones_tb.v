module one_tb;
     reg [9:0] A;  
     wire [4:0] ones;
    one uut (
        .A(A), 
        .ones(ones)
    );
     initial begin
        A = 10'b1111111111;  
        #400;
        $display("A = %b, ones = %d", A, ones);
         A = 10'b1111010111;  
        #400;
        $display("A = %b, ones = %d", A, ones);
         A = 10'b0011111111;  
        #400;
        $display("A = %b, ones = %d", A, ones);
         A = 10'b0000000001; 
        #400;
        $display("A = %b, ones = %d", A, ones);
         A = 10'b1111000011; 
        #400;
        $display("A = %b, ones = %d", A, ones);
         A = 10'b0111100000;  
        #400;
        $display("A = %b, ones = %d", A, ones);
         A = 10'b0111101111;  
        #400;
        $display("A = %b, ones = %d", A, ones);
      
     end
      
endmodule
