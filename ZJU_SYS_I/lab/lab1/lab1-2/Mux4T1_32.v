module Mux4T1_32(
    input [31:0] I0,
    input [31:0] I1,
    input [31:0] I2,
    input [31:0] I3,
    input [1:0] S,
    output reg [31:0] O
);
    always @(*) begin
        case (S)
            2'b00: O = I0;
            2'b01: O = I1;
            2'b10: O = I2;
            2'b11: O = I3;
            default: O = 2'bxx;
        endcase
    end
endmodule
