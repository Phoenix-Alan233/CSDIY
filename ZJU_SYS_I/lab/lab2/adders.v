module Adder32 #(
    parameter LENGTH = 32
)(
    input [LENGTH-1:0] a,
    input [LENGTH-1:0] b,
    input c_in,
    output [LENGTH-1:0] s,
    output c_out
);
    wire [LENGTH:0] c;
    assign c[0] = c_in;
    genvar i;
    generate
        for (i = 0; i < LENGTH; i = i + 1) begin : adder_inst
            Adder adder(
                .a(a[i]),
                .b(b[i]),
                .c_in(c[i]),
                .s(s[i]),
                .c_out(c[i + 1])
            );
        end
    endgenerate
endmodule