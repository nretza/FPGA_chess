
module chess_state(ascii, new_ascii, RESET, state);

input [7:0] ascii;
input       new_ascii;
input       RESET;

output reg [4:0] state;

always @ (posedge new_ascii or posedge RESET)
	begin
	
	if (RESET)
		state <= 4'b0101;
	
	else
		case (state)
		
			4'b0001: //Feld 1
					 if (ascii == 100) begin state <= 4'b0010;  end
				else if (ascii == 115) begin state <= 4'b0100;  end


            4'b0010: //Feld 2
					 if (ascii == 097) begin state <= 4'b0001;  end
				else if (ascii == 100) begin state <= 4'b0011;  end
                else if (ascii == 115) begin state <= 4'b0101;  end
            
            4'b0011: //Feld 3
					 if (ascii == 097) begin state <= 4'b0010;  end
				else if (ascii == 115) begin state <= 4'b0110;  end

            4'b0100: //Feld 4
					 if (ascii == 119) begin state <= 4'b0001;  end
				else if (ascii == 100) begin state <= 4'b0101;  end
                else if (ascii == 115) begin state <= 4'b0111;  end

            4'b0101: //Feld 5
					 if (ascii == 119) begin state <= 4'b0010;  end
				else if (ascii == 100) begin state <= 4'b0110;  end
                else if (ascii == 115) begin state <= 4'b1000;  end
                else if (ascii == 097) begin state <= 4'b0100;  end

            4'b0110: //Feld 6
					 if (ascii == 119) begin state <= 4'b0011;  end
				else if (ascii == 097) begin state <= 4'b0101;  end
                else if (ascii == 115) begin state <= 4'b1001;  end

            4'b0111: //Feld 7
					 if (ascii == 119) begin state <= 4'b0100;  end
				else if (ascii == 100) begin state <= 4'b1000;  end

            4'b1000: //Feld 8
					 if (ascii == 119) begin state <= 4'b0101;  end
				else if (ascii == 100) begin state <= 4'b1001;  end
                else if (ascii == 097) begin state <= 4'b0111;  end
				
            4'b1001: //Feld 9
					 if (ascii == 097) begin state <= 4'b1000;  end
				else if (ascii == 119) begin state <= 4'b0110;  end
			
            default: begin state <= 4'b0101; end
		endcase
	
	end

endmodule