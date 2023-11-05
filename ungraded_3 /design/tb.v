module test_bench;
  reg [63:0] A;
  reg [63:0] B;
  wire [63:0] Answer;
   
  Matrix_operation #(64, 2) calculator (.A(A), .B(B), .Result(Answer));
 initial begin
  A = {
  16'd1, 16'd2,  
  16'd10, 16'd11 
};

B = {
  16'd65, 16'd66,  
  16'd74, 16'd75 
};
  
    #100;

 
 
  end
endmodule
