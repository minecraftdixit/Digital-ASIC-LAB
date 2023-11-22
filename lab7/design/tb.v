module test_bench;

  reg [191:0] A;
  reg [191:0] B;
 
  wire [191:0] Sum;
  wire [191:0] Result;
 

  Matrix_operation #(192, 4, 3) calculator (.A(A), .B(B), .Result(Result), .Sum(Sum));

  initial begin
    A = {
      16'd1, 16'd2, 16'd3,
      16'd10, 16'd11, 16'd12,
      16'd19, 16'd20, 16'd21,
      16'd28, 16'd29, 16'd30
    };

    B = {
      16'd65, 16'd66, 16'd67, 16'd68,
      16'd74, 16'd75, 16'd76, 16'd77,
      16'd83, 16'd84, 16'd85, 16'd86
    };
  
    #500;
  end
endmodule
 
//Answer of multiplication
//462	468	    474	    480  =  1884
//2460	2493	2526	2559  = 10038
//4458	4518	4578	4638 = 18192 
//6456	6543	6630	6717 =26346

 // Sum is 56460
