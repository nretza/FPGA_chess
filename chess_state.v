
module chess_state(ascii, new_ascii, RESET, ENTER, state);

input [7:0] ascii;      // aktives ascii-signal
input       new_ascii;  // signal für neues ascii
input       RESET;      // Reset-Button
input 		ENTER;      // Enter-Button

output reg [4:0] state; // state output


///////////////// statemachine /////////////////////////////////

always @ (posedge ENTER or posedge RESET)
	begin
	
	if (RESET)
		state <= 4'b0101;
	
	else
		case (state)
		
			4'b0001: //Feld 1
					 if      (ascii == 8'h44) begin state <= 4'b0010;  end
				    else if (ascii == 8'h53) begin state <= 4'b0100;  end


            4'b0010: //Feld 2
					 if      (ascii == 8'h41) begin state <= 4'b0001;  end
				    else if (ascii == 8'h44) begin state <= 4'b0011;  end
                else if (ascii == 8'h53) begin state <= 4'b0101;  end
            
            4'b0011: //Feld 3
					 if      (ascii == 8'h41) begin state <= 4'b0010;  end
			     	 else if (ascii == 8'h53) begin state <= 4'b0110;  end

            4'b0100: //Feld 4
					 if      (ascii == 8'h57) begin state <= 4'b0001;  end
				    else if (ascii == 8'h44) begin state <= 4'b0101;  end
                else if (ascii == 8'h53) begin state <= 4'b0111;  end

            4'b0101: //Feld 5
					 if      (ascii == 8'h57) begin state <= 4'b0010;  end
				    else if (ascii == 8'h44) begin state <= 4'b0110;  end
                else if (ascii == 8'h53) begin state <= 4'b1000;  end
                else if (ascii == 8'h41) begin state <= 4'b0100;  end

            4'b0110: //Feld 6
					 if      (ascii == 8'h57) begin state <= 4'b0011;  end
				    else if (ascii == 8'h41) begin state <= 4'b0101;  end
                else if (ascii == 8'h53) begin state <= 4'b1001;  end

            4'b0111: //Feld 7
					 if      (ascii == 8'h57) begin state <= 4'b0100;  end
				    else if (ascii == 8'h44) begin state <= 4'b1000;  end

            4'b1000: //Feld 8
					 if      (ascii == 8'h57) begin state <= 4'b0101;  end
				    else if (ascii == 8'h44) begin state <= 4'b1001;  end
                else if (ascii == 8'h41) begin state <= 4'b0111;  end
				
            4'b1001: //Feld 9
					 if      (ascii == 8'h41) begin state <= 4'b1000;  end
				    else if (ascii == 8'h57) begin state <= 4'b0110;  end
			
            default: begin state <= 4'b0101; end
		endcase
	
	end

endmodule