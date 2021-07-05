module chess_display(state, clock, hcount, vcount, R, G, B)

input [3:0]     state;
input [10:0] 	hcount;
input [9:0]  	vcount;
input clock;

output [9:0]    R, G, B;


////// ARTWORK ////// aus : https://github.com/alexallsup/Chess-FPGA ///////////////////

localparam pawnArt [0:7][0:7] = {
	8'b00000000,
	8'b00000000,
	8'b00000000,
	8'b00000000,
	8'b00011000,
	8'b00111100,
	8'b01111110,
	8'b01111110
};

localparam bishopArt [0:7][0:7] = {
	8'b00000000,
	8'b00011000,
	8'b00111100,
	8'b00111100,
	8'b00011000,
	8'b00011000,
	8'b00111100,
	8'b11100111
};

localparam knightArt [0:7][0:7] = { 
	8'b00011000,
	8'b01111100,
	8'b11111110,
	8'b11101111,
	8'b00000111,
	8'b00011111,
	8'b00111111,
	8'b01111110
};

localparam queenArt [0:7][0:7] = { 
	8'b00000000,
	8'b01010101,
	8'b01010101,
	8'b01010101,
	8'b01010101,
	8'b01111111,
	8'b01111111,
	8'b01111111
};

localparam kingArt [0:7][0:7] = { 
	8'b00011000,
	8'b01111110,
	8'b00011000,
	8'b00011000,
	8'b00111100,
	8'b01111110,
	8'b01111110,
	8'b00111100
};

localparam rookArt [0:7][0:7] = { 
	8'b00000000,
	8'b01011010,
	8'b01111110,
	8'b00111100,
	8'b00011000,
	8'b00011000,
	8'b00111100,
	8'b01111110
};

localparam RGB_OUTSIDE = 8'b000_000_00;  // outside the drawn board
localparam RGB_DARK_SQ = 8'b101_000_00;  // color of the dark squares
localparam RGB_LIGHT_SQ = 8'b111_110_10; // color of the light squares
localparam RGB_BLACK_PIECE = 8'b001_001_01; // color of the black player's pieces
localparam RGB_WHITE_PIECE = 8'b111_111_11; // color of the white player's pieces

//////////////////////////////////////////////////////////////


wire [7:0] SQ_1 = (hcount>=200 && hcount<=300 && vcount>=200 && vcount<=300) ? RGB_LIGHT_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_2 = (hcount>=300 && hcount<=400 && vcount>=200 && vcount<=300) ? RGB_DARK_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_3 = (hcount>=400 && hcount<=500 && vcount>=200 && vcount<=300) ? RGB_LIGHT_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_4 = (hcount>=200 && hcount<=300 && vcount>=300 && vcount<=400) ? RGB_DARK_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_5 = (hcount>=300 && hcount<=400 && vcount>=300 && vcount<=400) ? RGB_LIGHT_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_6 = (hcount>=400 && hcount<=500 && vcount>=300 && vcount<=400) ? RGB_DARK_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_7 = (hcount>=200 && hcount<=300 && vcount>=400 && vcount<=500) ? RGB_LIGHT_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_8 = (hcount>=300 && hcount<=400 && vcount>=400 && vcount<=500) ? RGB_DARK_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_9 = (hcount>=400 && hcount<=500 && vcount>=500 && vcount<=500) ? RGB_LIGHT_SQ: RGB_OUTSIDE;

reg [7:0] fig;
reg [10:0] x_square, y_square, x_art, y_art;

always @(clock); begin

	R [9:7] <= SQ_1 [7:5] |  SQ_2 [7:5] |  SQ_3 [7:5] |  SQ_4 [7:5] |  SQ_5 [7:5] |  SQ_6 [7:5] |  SQ_7 [7:5] |  SQ_8 [7:5] |  SQ_9 [7:5];
	G [9:7] <= SQ_1 [4:2] |  SQ_2 [4:2] |  SQ_3 [4:2] |  SQ_4 [4:2] |  SQ_5 [4:2] |  SQ_6 [4:2] |  SQ_7 [4:2] |  SQ_8 [4:2] |  SQ_9 [4:2];
	B [9:8] <= SQ_1 [1:0] |  SQ_2 [1:0] |  SQ_3 [1:0] |  SQ_4 [1:0] |  SQ_5 [1:0] |  SQ_6 [1:0] |  SQ_7 [1:0] |  SQ_8 [1:0] |  SQ_9 [1:0];

	case (state)
		
		4'b0001: //Feld 1
			x_square <= hcount - 200;
			y_square <= vcount - 200;

        4'b0010: //Feld 2
			x_square <= hcount - 300;
			y_square <= vcount - 200;  

        4'b0011: //Feld 3
			x_square <= hcount - 400;
			y_square <= vcount - 200;  
			   
        4'b0100: //Feld 4
			x_square <= hcount - 200;
			y_square <= vcount - 300;  
			   
        4'b0101: //Feld 5
			x_square <= hcount - 300;
			y_square <= vcount - 300;  
			   
        4'b0110: //Feld 6
			x_square <= hcount - 400;
			y_square <= vcount - 300;  
			   
        4'b0111: //Feld 7
			x_square <= hcount - 200;
			y_square <= vcount - 400;  
			   
        4'b1000: //Feld 8
			x_square <= hcount - 300;
			y_square <= vcount - 400;  
			   				
        4'b1001: //Feld 9
			x_square <= hcount - 400;
			y_square <= vcount - 400;  

		default:
			x_square <= hcount - 300;
			y_square <= vcount - 300;

		endcase

	if 	    (x_square <= 15) x_art <= 0;
	else if (x_square <= 25) x_art <= 1;
	else if (x_square <= 35) x_art <= 2;
	else if (x_square <= 45) x_art <= 3;
	else if (x_square <= 55) x_art <= 4;
	else if (x_square <= 65) x_art <= 5;
	else if (x_square <= 75) x_art <= 6;
	else 				     x_art <= 7;	

	if 	    (y_square <= 15) y_art <= 0;
	else if (y_square <= 25) y_art <= 1;
	else if (y_square <= 35) y_art <= 2;
	else if (y_square <= 45) y_art <= 3;
	else if (y_square <= 55) y_art <= 4;
	else if (y_square <= 65) y_art <= 5;
	else if (y_square <= 75) y_art <= 6;
	else 				     y_art <= 7;
	
	if (queenArt [x_art][y_art] && x_square>=0 && x_square<=100 && y_square>=0 && y_square<=100) begin
		R [9:7] <= RGB_WHITE_PIECE [7:5];
		G [9:7] <= RGB_WHITE_PIECE [4:2];
		B [9:8] <= RGB_WHITE_PIECE [1:0];
	end

end