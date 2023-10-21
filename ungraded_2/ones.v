module one(
    input [9:0] A,
    output reg [4:0] ones
    );

integer i;

always@(A)
begin
    ones = 0;  //initialize count variable.
    for(i=0;i<10;i=i+1)    
        ones = ones + A[i];  
end

endmodule
