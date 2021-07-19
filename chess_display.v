module chess_display(state, clock, hcount, vcount, R, G, B);

input [3:0]     state;  // state des Schachfeldes
input [10:0] 	hcount; // aus vga-modul
input [9:0]  	vcount; // aus vga-modul
input clock;

output reg [9:0]   R, G, B; // RGB-werte


////// ARTWORK ////// Farben aus : https://github.com/alexallsup/Chess-FPGA ///////////////////


parameter RGB_OUTSIDE = 8'b000_000_00;  // outside the drawn board
parameter RGB_DARK_SQ = 8'b101_000_00;  // color of the dark squares
parameter RGB_LIGHT_SQ = 8'b111_110_10; // color of the light squares
parameter RGB_BLACK_PIECE = 8'b001_001_01; // color of the black player's pieces
parameter RGB_WHITE_PIECE = 8'b111_111_11; // color of the white player's pieces

reg [99:0] queenArt = {100'b0000000000_0000110000_0001111000_0001111000_0000110000_0000110000_0000110000_0011111100_0111111110_0000000000};


////////// Felder ///////////////////////////////////////////////

wire [7:0] SQ_1 = (hcount>=200 && hcount<=300 && vcount>=200 && vcount<=300) ? RGB_LIGHT_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_2 = (hcount>=300 && hcount<=400 && vcount>=200 && vcount<=300) ? RGB_DARK_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_3 = (hcount>=400 && hcount<=500 && vcount>=200 && vcount<=300) ? RGB_LIGHT_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_4 = (hcount>=200 && hcount<=300 && vcount>=300 && vcount<=400) ? RGB_DARK_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_5 = (hcount>=300 && hcount<=400 && vcount>=300 && vcount<=400) ? RGB_LIGHT_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_6 = (hcount>=400 && hcount<=500 && vcount>=300 && vcount<=400) ? RGB_DARK_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_7 = (hcount>=200 && hcount<=300 && vcount>=400 && vcount<=500) ? RGB_LIGHT_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_8 = (hcount>=300 && hcount<=400 && vcount>=400 && vcount<=500) ? RGB_DARK_SQ: RGB_OUTSIDE; 
wire [7:0] SQ_9 = (hcount>=400 && hcount<=500 && vcount>=400 && vcount<=500) ? RGB_LIGHT_SQ: RGB_OUTSIDE;


///////// Koordinaten regs ///////////////////////////////////

reg [10:0] x_square, y_square, x_art, y_art;
reg [12:0] xy_art;


///////// Drawing ////////////////////////////////////////////

always @(clock) begin

	// Felder
	R [9:7] <= SQ_1 [7:5] |  SQ_2 [7:5] |  SQ_3 [7:5] |  SQ_4 [7:5] |  SQ_5 [7:5] |  SQ_6 [7:5] |  SQ_7 [7:5] |  SQ_8 [7:5] |  SQ_9 [7:5];
	G [9:7] <= SQ_1 [4:2] |  SQ_2 [4:2] |  SQ_3 [4:2] |  SQ_4 [4:2] |  SQ_5 [4:2] |  SQ_6 [4:2] |  SQ_7 [4:2] |  SQ_8 [4:2] |  SQ_9 [4:2];
	B [9:8] <= SQ_1 [1:0] |  SQ_2 [1:0] |  SQ_3 [1:0] |  SQ_4 [1:0] |  SQ_5 [1:0] |  SQ_6 [1:0] |  SQ_7 [1:0] |  SQ_8 [1:0] |  SQ_9 [1:0];

	//Evaluieren des state
	case (state)
		
		4'b0001: //Feld 1
			begin
			x_square <= hcount - 200;
			y_square <= vcount - 200;
			end
      4'b0010: //Feld 2
		  begin
			x_square <= hcount - 300;
			y_square <= vcount - 200;
			end
			
      4'b0011: //Feld 3
			begin
			x_square <= hcount - 400;
			y_square <= vcount - 200;
			end
			
			4'b0100: //Feld 4
			begin
			x_square <= hcount - 200;
			y_square <= vcount - 300;
			end   
			
      4'b0101: //Feld 5
			begin
			x_square <= hcount - 300;
			y_square <= vcount - 300;
			end
			
      4'b0110: //Feld 6
			begin
			x_square <= hcount - 400;
			y_square <= vcount - 300;
			end
			
		4'b0111: //Feld 7
			begin
			x_square <= hcount - 200;
			y_square <= vcount - 400;
			end
			
      4'b1000: //Feld 8
			begin
			x_square <= hcount - 300;
			y_square <= vcount - 400;
			end
			
      4'b1001: //Feld 9
			begin
			x_square <= hcount - 400;
			y_square <= vcount - 400;
			end
			
		default:
			begin
			x_square <= hcount - 300;
			y_square <= vcount - 300;
			end
			
		endcase

	// Hochskalieren der Figur in x
	if 	  (x_square <= 10) x_art <= 0;
	else if (x_square <= 20) x_art <= 1;
	else if (x_square <= 30) x_art <= 2;
	else if (x_square <= 40) x_art <= 3;
	else if (x_square <= 50) x_art <= 4;
	else if (x_square <= 60) x_art <= 5;
	else if (x_square <= 70) x_art <= 6;
	else if (x_square <= 80) x_art <= 7;
	else if (x_square <= 90) x_art <= 8;
	else 				          x_art <= 9;	

	// Hochskalieren der Figur in y
	if 	  (y_square <= 10) y_art <= 9;
	else if (y_square <= 20) y_art <= 8;
	else if (y_square <= 30) y_art <= 7;
	else if (y_square <= 40) y_art <= 6;
	else if (y_square <= 50) y_art <= 5;
	else if (y_square <= 60) y_art <= 4;
	else if (y_square <= 70) y_art <= 3;
	else if (y_square <= 80) y_art <= 2;
	else if (y_square <= 90) y_art <= 1;
	else 				          y_art <= 0;
	
	xy_art = x_art + 10*y_art;
	
	// Überschreiben des Feldes mit Figur
	if (queenArt [xy_art] && x_square>=0 && x_square<=100 && y_square>=0 && y_square<=100) begin
		R [9:7] <= RGB_WHITE_PIECE [7:5];
		G [9:7] <= RGB_WHITE_PIECE [4:2];
		B [9:8] <= RGB_WHITE_PIECE [1:0];
	end
	
end

endmodule