module chess (LED_R, CLOCK_50, CLOCK_27, KEY, PS2_CLK, PS2_DAT, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B, VGA_BLANK, VGA_CLK);

input 		CLOCK_50;
input	    CLOCK_27;
input [3:0] KEY;
input 		PS2_CLK, PS2_DAT;

output     [6:0] 	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
output 			    VGA_HS, VGA_VS, VGA_BLANK, VGA_CLK;
output     [9:0] 	VGA_R, VGA_G, VGA_B;

output     [17:0]   LED_R;


/////////////////////// RESET //////////////////////////////////////

wire    RESET;
wire	  ENTER;

assign  RESET = ~KEY[0];
assign  ENTER = ~KEY[3];

/////////////////////// pixel clock 65 MHz /////////////////////////

wire  CLOCK_65;

pll65 pll0 (CLOCK_50, CLOCK_65);


/////////////////////// XVGA video signals /////////////////////////

wire 	[10:0] 	hcount;
wire 	[9:0]  	vcount;
wire 			   hsync, vsync, blank;

xvga xvga0 (CLOCK_65, hcount, vcount, hsync, vsync, blank);

assign VGA_HS = hsync;
assign VGA_VS = vsync;
assign VGA_BLANK = ~blank;
assign VGA_CLK = CLOCK_65;


///////////////////////// keyboard input /////////////////////////// 

wire ready;
wire [7:0] ascii_char;

ps2decoder (CLOCK_27, RESET, PS2_CLK, PS2_DAT, ascii_char, ready);

wire [3:0] hex_char;

asciidecoder (ascii_char, hex_char);

hexdisplay	h1(hex_char, HEX4); //für debug
hexdisplay	h2(hex_char, HEX5); //für debug

assign LED_R[0] = ready;

//////////////////// chess state machine ////////////////////////

wire [4:0] state;
wire [7:0] tmp = {1'b0,1'b0,1'b0,state[4],state[3],state[2],state[1],state[0]};

chess_state c0(ascii_char, ready, RESET, ENTER, state);

bcddisplay h3(tmp, HEX3, HEX2, HEX1, HEX0); //für debug

////////////////////////// display //////////////////////////////

wire [9:0]  R,G,B;

chess_display d1 (state, CLOCK_65, hcount, vcount, R, G, B);

assign VGA_R = R;
assign VGA_G = G;
assign VGA_B = B;

endmodule