module Mux8T1_1( 
    input [7:0] I,
    input [2:0] S,
    output O 
);
    wire O0, O1;
    Mux4T1_1 mux0(I[0], I[1], I[2], I[3], O0, S[1:0]);
    Mux4T1_1 mux1(I[4], I[5], I[6], I[7], O1, S[1:0]);
    assign O = S[2] ? O1 : O0;
endmodule