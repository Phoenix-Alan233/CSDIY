module AddSubers #(
    parameter LENGTH = 32  // 全加减法器的宽度
)(
    input [LENGTH-1:0] a,  // 被加数 / 被减数
    input [LENGTH-1:0] b,  // 加数 / 减数
    input do_sub,          // 0 表示加法, 1 表示减法
    output [LENGTH-1:0] s, // 和 / 差
    output c               // 进位 / 借位
);
    assign tmpb = do_sub ? b ^ {LENGTH{1'b1}} : b;
    Adder32 adder32(
        .a(a),
        .b(tmpb),
        .c_in(do_sub),
        .s(s),
        .c_out(c)
    );
endmodule