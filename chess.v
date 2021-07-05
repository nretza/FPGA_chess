module chess (CLOCK_50, CLOCK_27, KEY, PS2_CLK, PS2_DAT, HEX0, HEX1, HEX2, HEX3, VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B, VGA_BLANK, VGA_CLK);

input 			CLOCK_50;
input	 		CLOCK_27;
input 	     	KEY;
input 			PS2_CLK, PS2_DAT;

output 	[6:0] 	HEX3, HEX2, HEX1, HEX0;
output 			VGA_HS, VGA_VS, VGA_BLANK, VGA_CLK;
output 	[9:0] 	VGA_R, VGA_G, VGA_B;

reg 	[9:0] 	VGA_R, VGA_G, VGA_B;


/////////////////////// RESET //////////////////////////////////////

wire    RESET;
assign  RESET = ~KEY;


/////////////////////// pixel clock 65 MHz /////////////////////////

wire  CLOCK_65;

pll65 pll0 (CLOCK_50, CLOCK_65);


/////////////////////// XVGA video signals /////////////////////////

wire 	[10:0] 	hcount;
wire 	[9:0]  	vcount;
wire 			hsync, vsync, blank;

xvga xvga0 (CLOCK_65, hcount, vcount, hsync, vsync, blank);

assign VGA_HS = hsync;
assign VGA_VS = vsync;
assign VGA_BLANK = blank;
assign VGA_CLK = CLOCK_65;


///////////////////////// keyboard input /////////////////////////// 

wire 			new_ascii;
wire 	[7:0] 	ascii;
wire 	[7:0] 	ps2_code;

hexdisplay h3 (	0, HEX3	);
hexdisplay h2 (	0, HEX2	);
hexdisplay h1 (	ps2_code[7:4], HEX1 );
hexdisplay h0 (	ps2_code[3:0], HEX0 );

ps2_keyboard p0 (CLOCK_27, RESET, PS2_CLK, PS2_DAT, ascii, new_ascii, ps2_code);


//////////////////// chess state machine ////////////////////////

reg [4:0] state;
chess_state c0(ascii, new_ascii, RESET, state);


////////////////////////// display //////////////////////////////

wire [9:0]  R,G,B;

chess_display d1 (state, CLOCK_65, hcount, vcount, R, G, B);

assign VGA_R = R;
assign VGA_G = G;
assign VGA_B = B;

endmodule