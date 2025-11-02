module main(
    input I0, I1, I2, I3,
    output O
);
    wire res1, res2, res3, res4, res5;
    assign res1 = ~I1 & ~I2 & ~I3;
    assign res2 = ~I0 & I2 & ~I1;
    assign res3 = ~I0 & I1 & I3;
    assign res4 = I2 & I3;
    assign res5 = I0 & I2;
    assign O = res1 | res2 | res3 | res4 | res5;
endmodule