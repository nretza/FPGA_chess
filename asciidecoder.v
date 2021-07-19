///////////// aus LAB /////////////////////////

module asciidecoder (ascii_in, hex_out);

input [7:0] ascii_in;
output [3:0] hex_out;

reg [3:0] hex_reg;

always @ (ascii_in)
case (ascii_in)
8'h30: hex_reg[3:0] = 4'h0; // 0
8'h31: hex_reg[3:0] = 4'h1; // 1
8'h32: hex_reg[3:0] = 4'h2; // 2
8'h33: hex_reg[3:0] = 4'h3; // 3
8'h34: hex_reg[3:0] = 4'h4; // 4
8'h35: hex_reg[3:0] = 4'h5; // 5
8'h36: hex_reg[3:0] = 4'h6; // 6
8'h37: hex_reg[3:0] = 4'h7; // 7
8'h38: hex_reg[3:0] = 4'h8; // 8
8'h39: hex_reg[3:0] = 4'h9; // 9

8'h57: hex_reg[3:0] = 4'h1; // W
8'h41: hex_reg[3:0] = 4'h2; // A
8'h53: hex_reg[3:0] = 4'h3; // S
8'h44: hex_reg[3:0] = 4'h4; // D

default: hex_reg[3:0] = 4'h0; // default 0
endcase

assign hex_out = hex_reg;

endmodule