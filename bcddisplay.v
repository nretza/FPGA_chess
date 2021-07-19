///////////// aus LAB /////////////////////////

module bcddisplay (b, out_HEX3, out_HEX2, out_HEX1, out_HEX0);

input [7:0] b;
output [6:0] out_HEX3, out_HEX2, out_HEX1, out_HEX0;

wire [3:0] c1,c2,c3,c4,c5,c6,c7;
wire [3:0] d1,d2,d3,d4,d5,d6,d7;

assign d1 = {1'b0, b[7:5]};
assign d2 = {c1[2:0], b[4]};
assign d3 = {c2[2:0], b[3]};
assign d4 = {c3[2:0], b[2]};
assign d5 = {c4[2:0], b[1]};
assign d6 = {1'b0, c1[3], c2[3], c3[3]};
 assign d7 = {c6[2:0], c4[3]};

add3 a1(d1, c1);
add3 a2(d2, c2);
add3 a3(d3, c3);
add3 a4(d4, c4);
add3 a5(d5, c5);
add3 a6(d6, c6);
add3 a7(d7, c7);

wire [3:0] ONES = {c5[2:0], b[0]};
wire [3:0] TENS = {c7[2:0], c5[3]};
wire [3:0] HUNDREDS = {2'b00, c6[3], c7[3]};

hexdisplay u0 (ONES, out_HEX0);
hexdisplay u1 (TENS, out_HEX1);
hexdisplay u2 (HUNDREDS, out_HEX2);
hexdisplay u3 (4'b0000, out_HEX3);

endmodule