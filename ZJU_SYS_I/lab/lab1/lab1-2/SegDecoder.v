`timescale 1ns / 1ps

module SegDecoder (
    input  wire [3:0] data,
    input  wire       point,
    input  wire       LE,

    output wire       a,
    output wire       b,
    output wire       c,
    output wire       d,
    output wire       e,
    output wire       f,
    output wire       g,
    output wire       p
);

    wire wire0, wire1, wire2, wire3;
    wire inv_wire0, inv_wire1, inv_wire2, inv_wire3;

    assign {wire3, wire2, wire1, wire0} = data;
    assign {inv_wire0, inv_wire1, inv_wire2, inv_wire3} = {~wire0, ~wire1, ~wire2, ~wire3};

    // minterms for number 0-f
    wire [15:0] and_gate;
    assign and_gate[0]  = inv_wire0 & inv_wire1 & inv_wire2 & inv_wire3;  // 0: 0000
    assign and_gate[1]  = wire0     & inv_wire1 & inv_wire2 & inv_wire3;  // 1: 0001
    assign and_gate[2]  = inv_wire0 & wire1     & inv_wire2 & inv_wire3;  // 2: 0010
    assign and_gate[3]  = wire0     & wire1     & inv_wire2 & inv_wire3;  // 3: 0011
    assign and_gate[4]  = inv_wire0 & inv_wire1 & wire2     & inv_wire3;  // 4: 0100
    assign and_gate[5]  = wire0     & inv_wire1 & wire2     & inv_wire3;  // 5: 0101
    assign and_gate[6]  = inv_wire0 & wire1     & wire2     & inv_wire3;  // 6: 0110
    assign and_gate[7]  = wire0     & wire1     & wire2     & inv_wire3;  // 7: 0111
    assign and_gate[8]  = inv_wire0 & inv_wire1 & inv_wire2 & wire3;      // 8: 1000
    assign and_gate[9]  = wire0     & inv_wire1 & inv_wire2 & wire3;      // 9: 1001
    assign and_gate[10] = inv_wire0 & wire1     & inv_wire2 & wire3;      // A: 1010
    assign and_gate[11] = wire0     & wire1     & inv_wire2 & wire3;      // B: 1011
    assign and_gate[12] = inv_wire0 & inv_wire1 & wire2     & wire3;      // C: 1100
    assign and_gate[13] = wire0     & inv_wire1 & wire2     & wire3;      // D: 1101
    assign and_gate[14] = inv_wire0 & wire1     & wire2     & wire3;      // E: 1110
    assign and_gate[15] = wire0     & wire1     & wire2     & wire3;      // F: 1111

    // SegDecoder for a
    wire a_or, a_result;
    assign a_or     = and_gate[1] | and_gate[4] | and_gate[11] | and_gate[13];
    assign a_result = a_or | LE;
    assign a        = a_result;

    // SegDecoder for b
    wire b_or, b_result;
    assign b_or     = and_gate[5] | and_gate[6] | and_gate[11] | and_gate[12] | and_gate[14] | and_gate[15];
    assign b_result = b_or | LE;
    assign b        = b_result;

    // SegDecoder for c
    wire c_or, c_result;
    assign c_or     = and_gate[2] | and_gate[12] | and_gate[14] | and_gate[15];
    assign c_result = c_or | LE;
    assign c        = c_result;

    // SegDecoder for d: 1, 4, 7, 10, 15
    wire d_or, d_result;
    assign d_or     = and_gate[1] | and_gate[4] | and_gate[7] | and_gate[10] | and_gate[15];
    assign d_result = d_or | LE;
    assign d        = d_result;

    // SegDecoder for e: 1, 3, 4, 5, 7, 9
    wire e_or, e_result;
    assign e_or     = and_gate[1] | and_gate[3] | and_gate[4] | and_gate[5] | and_gate[7] | and_gate[9];
    assign e_result = e_or | LE;
    assign e        = e_result;

    // SegDecoder for f: 1, 2, 3, 7, 13
    wire f_or, f_result;
    assign f_or     = and_gate[1] | and_gate[2] | and_gate[3] | and_gate[7] | and_gate[13];
    assign f_result = f_or | LE;
    assign f        = f_result;

    // SegDecoder for g: 0, 1, 7, 12
    wire g_or, g_result;
    assign g_or     = and_gate[0] | and_gate[1] | and_gate[7] | and_gate[12];
    assign g_result = g_or | LE;
    assign g        = g_result;

    // p
    assign p = ~point;

endmodule