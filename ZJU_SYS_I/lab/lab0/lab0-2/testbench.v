module Testbench;

    reg I0, I1, I2;
    wire O;

    // 生成测试激励
    initial begin
        I0 = 1'b0;
        I1 = 1'b0;
        I2 = 1'b0;
        #5;

        I0 = 1'b0;
        I1 = 1'b0;
        I2 = 1'b1;
        #5;

        I0 = 1'b0;
        I1 = 1'b1;
        I2 = 1'b0;
        #5;

        I0 = 1'b0;
        I1 = 1'b1;
        I2 = 1'b1;
        #5;

        I0 = 1'b1;
        I1 = 1'b0;
        I2 = 1'b0;
        #5;

        I0 = 1'b1;
        I1 = 1'b0;
        I2 = 1'b1;
        #5;

        I0 = 1'b1;
        I1 = 1'b1;
        I2 = 1'b0;
        #5;

        I0 = 1'b1;
        I1 = 1'b1;
        I2 = 1'b1;
        #5;

        $finish;
    end

    main dut(
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .O(O)
    );

    // 如果使用 Verilator，生成波形文件
    `ifdef VERILATE
        initial begin
            // 生成波形文件路径
            $dumpfile({`TOP_DIR, "/Testbench.vcd"});
            // 记录 dut 模块的所有信号变化
            $dumpvars(0, dut);
            // 开始记录
            $dumpon;
        end
    `endif

endmodule