///////////// aus LAB /////////////////////////

module ps2decoder (clock_27mhz, reset, clock, data, ascii, ascii_ready);

// Author: C. Terman, 6.111 Course, MIT

input clock_27mhz;		// this module works synchronously with the system clock
input reset; 	 		// Active high asynchronous reset
input clock; 	 		// PS/2 clock
input data;  	 		// PS/2 data

output [7:0] ascii;		// ascii code (1 character)
output ascii_ready;		// ascii ready (one clock_27mhz cycle active high)

reg [7:0] ascii_val;	// internal combinatorial ascii decoded value
reg [7:0] lastkey;		// last keycode
reg [7:0] curkey;		// current keycode
reg [7:0] ascii;		// ascii output (latched & synchronous)
reg ascii_ready;		// synchronous one-cycle ready flag
reg key_ready;
   
wire fifo_rd;			// keyboard read request
wire [7:0] fifo_data;	// keyboard data
wire fifo_empty;		// flag: no keyboard data
wire fifo_overflow;		// keyboard data overflow

ps2reader (reset, clock_27mhz, clock, data, fifo_rd, fifo_data, fifo_empty, fifo_overflow);

assign fifo_rd = ~fifo_empty;	// continous read

always @(posedge clock_27mhz) begin
	// get key if ready
	curkey <= ~fifo_empty ? fifo_data : curkey;
	lastkey <= ~fifo_empty ? curkey : lastkey;
	key_ready  <= ~fifo_empty;

	// raise ascii_ready for last key which was read
	ascii_ready <= key_ready & ~(curkey[7]|lastkey[7]);
	ascii <=  (key_ready & ~(curkey[7]|lastkey[7])) ? ascii_val : ascii;
end

always @(curkey) begin //convert PS2 keyboard code ==> ascii code
	case (curkey)	
       8'h1C: ascii_val = 8'h41;		//A
       8'h32: ascii_val = 8'h42;		//B
       8'h21: ascii_val = 8'h43;		//C
       8'h23: ascii_val = 8'h44;		//D
       8'h24: ascii_val = 8'h45;		//E
       8'h2B: ascii_val = 8'h46;		//F
       8'h34: ascii_val = 8'h47;		//G
       8'h33: ascii_val = 8'h48;		//H
       8'h43: ascii_val = 8'h49;		//I
       8'h3B: ascii_val = 8'h4A;		//J
       8'h42: ascii_val = 8'h4B;		//K
       8'h4B: ascii_val = 8'h4C;		//L
       8'h3A: ascii_val = 8'h4D;		//M
       8'h31: ascii_val = 8'h4E;		//N
       8'h44: ascii_val = 8'h4F;		//O
       8'h4D: ascii_val = 8'h50;		//P
       8'h15: ascii_val = 8'h51;		//Q
       8'h2D: ascii_val = 8'h52;		//R
       8'h1B: ascii_val = 8'h53;		//S
       8'h2C: ascii_val = 8'h54;		//T
       8'h3C: ascii_val = 8'h55;		//U
       8'h2A: ascii_val = 8'h56;		//V
       8'h1D: ascii_val = 8'h57;		//W
       8'h22: ascii_val = 8'h58;		//X
       8'h35: ascii_val = 8'h59;		//Y
       8'h1A: ascii_val = 8'h5A;		//Z
       
       8'h45: ascii_val = 8'h30;		//0
       8'h16: ascii_val = 8'h31;		//1
       8'h1E: ascii_val = 8'h32;		//2
       8'h26: ascii_val = 8'h33;		//3
       8'h25: ascii_val = 8'h34;		//4
       8'h2E: ascii_val = 8'h35;		//5
       8'h36: ascii_val = 8'h36;		//6
       8'h3D: ascii_val = 8'h37;		//7
       8'h3E: ascii_val = 8'h38;		//8
       8'h46: ascii_val = 8'h39;		//9
       
       8'h0E: ascii_val = 8'h60;		// `
       8'h4E: ascii_val = 8'h2D;		// -
       8'h55: ascii_val = 8'h3D;		// =
       8'h5C: ascii_val = 8'h5C;		// \
       8'h29: ascii_val = 8'h20;		// space
       8'h54: ascii_val = 8'h5B;		// [
       8'h5B: ascii_val = 8'h5D;		// ] 
       8'h4C: ascii_val = 8'h3B;		// ;
       8'h52: ascii_val = 8'h27;		// '
       8'h41: ascii_val = 8'h2C;		// ,
       8'h49: ascii_val = 8'h2E;		// .
       8'h4A: ascii_val = 8'h2F;		// /
       
       8'h5A: ascii_val = 8'h0D;		// enter (CR)
       8'h66: ascii_val = 8'h08;		// backspace
       
       //  8'hF0: ascii_val = 8'hF0;		// BREAK CODE
       
       default: ascii_val = 8'h23;		// #
	endcase
end
   
endmodule


module ps2reader (reset, clock_27mhz, ps2c, ps2d, fifo_rd, fifo_data, fifo_empty, fifo_overflow);

input clock_27mhz;			// local clock
input reset;				// reset possibility
input ps2c;					// ps2 clock
input ps2d;					// ps2 data
input fifo_rd;				// fifo read request (active high)
   
output [7:0] fifo_data;		// fifo data output
output fifo_empty;			// fifo empty (active high)
output reg fifo_overflow;	// fifo overflow - too much kbd input

reg [7:0] fifo[7:0];		// 8 element data fifo
reg [3:0] count;			// count incoming data bits
reg [9:0] shift;			// accumulate incoming data bits
reg [2:0] wptr, rptr;		// fifo write and read pointers
reg [2:0] ps2c_sync;		// synchronize PS2 to local clock

wire [2:0] wptr_inc = wptr + 1;

assign fifo_empty = (wptr == rptr);
assign fifo_data = fifo[rptr];

// synchronize PS2 clock to local clock and look for falling edge
  
always @ (posedge clock_27mhz) 
	ps2c_sync <= {ps2c_sync[1:0],ps2c};
	
wire sample = ps2c_sync[2] & ~ps2c_sync[1];

always @ (posedge clock_27mhz) begin
	if (reset) begin  count <= 0; wptr <= 0; rptr <= 0; fifo_overflow <= 0; end
    
	else if (sample) begin
		// order of arrival: 0,8 bits of data (LSB first),odd parity,1
		if (count==10) begin // just received what should be the stop bit        
			if (shift[0]==0 && ps2d==1 && (^shift[9:1])==1) begin
				fifo[wptr] <= shift[8:1];
				wptr <= wptr_inc;
				fifo_overflow <= fifo_overflow | (wptr_inc == rptr);
			end
			count <= 0;
		end 
		else begin
			shift <= {ps2d,shift[9:1]};
			count <= count + 1;
		end
	end
   
    
	if (fifo_rd && !fifo_empty) begin
		rptr <= rptr + 1;	// bump read pointer if we're done with current value.
		fifo_overflow <= 0; // Read resets the overflow indicator
	end
end

endmodule
