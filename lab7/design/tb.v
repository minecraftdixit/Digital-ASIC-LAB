module test_bench;
  reg [1023:0] A;
  reg [1023:0] B;
  wire [1023:0] Answer;
  reg Mode;   
  Matrix_operation #(1024, 8) calculator (.A(A), .B(B), .Mode(Mode), .Result(Answer));
  initial begin
  A = {
  16'd1, 16'd2, 16'd3, 16'd4, 16'd5, 16'd6, 16'd7, 16'd8, 16'd9,
  16'd10, 16'd11, 16'd12, 16'd13, 16'd14, 16'd15, 16'd16, 16'd17, 16'd18,
  16'd19, 16'd20, 16'd21, 16'd22, 16'd23, 16'd24, 16'd25, 16'd26, 16'd27,
  16'd28, 16'd29, 16'd30, 16'd31, 16'd32, 16'd33, 16'd34, 16'd35, 16'd36,
  16'd37, 16'd38, 16'd39, 16'd40, 16'd41, 16'd42, 16'd43, 16'd44, 16'd45,
  16'd46, 16'd47, 16'd48, 16'd49, 16'd50, 16'd51, 16'd52, 16'd53, 16'd54,
  16'd55, 16'd56, 16'd57, 16'd58, 16'd59, 16'd60, 16'd61, 16'd62, 16'd63, 16'd64
};

B = {
  16'd65, 16'd66, 16'd67, 16'd68, 16'd69, 16'd70, 16'd71, 16'd72, 16'd73,
  16'd74, 16'd75, 16'd76, 16'd77, 16'd78, 16'd79, 16'd80, 16'd81, 16'd82,
  16'd83, 16'd84, 16'd85, 16'd86, 16'd87, 16'd88, 16'd89, 16'd90, 16'd91,
  16'd92, 16'd93, 16'd94, 16'd95, 16'd96, 16'd97, 16'd98, 16'd99, 16'd100,
  16'd101, 16'd102, 16'd103, 16'd104, 16'd105, 16'd106, 16'd107, 16'd108, 16'd109,
  16'd110, 16'd111, 16'd112, 16'd113, 16'd114, 16'd115, 16'd116, 16'd117, 16'd118,
  16'd119, 16'd120, 16'd121, 16'd122, 16'd123, 16'd124, 16'd125, 16'd126, 16'd127, 16'd128
};
           Mode = 0;  // Set Mode to 0 for addition

   
//    $display("A = %d %d %d %d %d %d %d %d %d", A[143:136], A[135:128], A[127:120], A[119:112], A[111:104], A[103:96], A[95:88], A[87:80], A[79:72]);
//    $display("B = %d %d %d %d %d %d %d %d %d", B[143:136], B[135:128], B[127:120], B[119:112], B[111:104], B[103:96], B[95:88], B[87:80], B[79:72]);
     
    #100;

    // Display the result (Answer) for addition
//    $display("Answer {addition = %d %d %d %d %d %d %d %d %d", Answer[143:136], Answer[135:128], Answer[127:120], Answer[119:112], Answer[111:104], Answer[103:96], Answer[95:88], Answer[87:80], Answer[79:72]);
    
   
    Mode = 1;
    #100;

    // Display the result (Answer) after subtraction
//    $display("Answer (Subtraction) = %d %d %d %d %d %d %d %d %d", Answer[143:136], Answer[135:128], Answer[127:120], Answer[119:112], Answer[111:104], Answer[103:96], Answer[95:88], Answer[87:80], Answer[79:72]);

 
  end
endmodule
