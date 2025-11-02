module Adder(
    input a,     // 被加数
    input b,     // 加数
    input c_in,  // 低位加法运算的进位 carry
    output s,    // 和 summary
    output c_out // 进位 carry
);
    assign s = a ^ b ^ c_in;
    assign c_out = (a & b) | (c_in & (a ^ b));
endmodule