module Testbench;

    reg [7:0] I;
    reg [2:0] S;
    wire O;

    initial begin
        S = 0; I = 8'b11111111;
        #5;
        S = 0; I = 8'b11111110;
        #5;
        S = 1; I = 8'b11111101;
        #5;
        S = 1; I = 8'b00000010;
        #5;
        S = 2; I = 8'b01110101;
        #5;
        S = 2; I = 8'b11111011;
        #5;
        S = 3; I = 8'b10010101;
        #5;
        S = 3; I = 8'b11111000;
        #5;
        S = 4; I = 8'b11101111;
        #5;
        S = 4; I = 8'b00011111;
        #5;
        S = 5; I = 8'b10100111;
        #5;
        S = 5; I = 8'b10010000;
        #5;
        S = 6; I = 8'b01001001;
        #5;
        S = 6; I = 8'b00111111;
        #5;
        S = 7; I = 8'b10101011;
        #5;
        S = 7; I = 8'b00101010;
        #5;
        $finish;
    end

    Mux8T1_1 dut( 
        .I(I),
        .S(S),
        .O(O) 
    );

    `ifdef VERILATE
		initial begin
			$dumpfile({`TOP_DIR,"/Testbench.vcd"});
			$dumpvars(0,dut);
			$dumpon;
		end
    `endif
    
endmodule
