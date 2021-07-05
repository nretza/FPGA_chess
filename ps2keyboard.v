module ps2keyboard (CLOCK_27, PS2_CLK, PS2_DAT, KEY, HEX0, HEX1, HEX2, HEX3);

input CLOCK_27;
input PS2_CLK, PS2_DAT;
input [3:0] KEY;

output [6:0] HEX0, HEX1, HEX2, HEX3;

wire ready;
wire [7:0] ascii_char;

ps2decoder (CLOCK_27, ~KEY[0], PS2_CLK, PS2_DAT, ascii_char, ready);

wire [3:0] hex_char;

asciidecoder (ascii_char, hex_char);

hexdisplay	h0(hex_char, HEX0);
hexdisplay	h1(hex_char, HEX1);
hexdisplay	h2(hex_char, HEX2);
hexdisplay	h3(hex_char, HEX3);


endmodule
