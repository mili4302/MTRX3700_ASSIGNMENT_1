module display (
    input   clk,
    input   [2:0]   direction_sign,
    output reg [6:0] segments0, segments1, segments2, segments3
);

    enum { Forward, Reverse, Left, Right } direction_display;

    always_comb begin
        case (direction_display)
            Forward: begin
			    	segments0 <= 7'b1111111;
				    segments1 <= 7'b1111111;
    				segments2 <= 7'b0001110;
	    			segments3 <= 7'b1111111;
		    	end
		    Reverse: begin
			    	segments0 <= 7'b0101111;
				    segments1 <= 7'b1111111;
				    segments2 <= 7'b1111111;
    				segments3 <= 7'b1111111;
	    	    end
		    Left: begin
			    	segments0 <= 7'b1111111;
				    segments1 <= 7'b1000111;
	    			segments2 <= 7'b1111111;
		    		segments3 <= 7'b1111111;
			    end
    		Right: begin
	    			segments0 <= 7'b1111111;
		    		segments1 <= 7'b1111111;
			    	segments2 <= 7'b1111111;
    				segments3 <= 7'b0000011;
	    	    end
            default: begin
			    	segments0 <= 7'b1111111;
				    segments1 <= 7'b1111111;
    				segments2 <= 7'b1111111;
	    			segments3 <= 7'b1111111;
            end
        endcase
    end

    always_ff @( posedge clk ) begin
        if (direction_sign == 2'b00) begin
            direction_display <= Forward;
        end
        else if (direction_sign == 2'b01) begin
            direction_display <= Reverse;
        end
        else if (direction_sign == 2'b10) begin
            direction_display <= Left;
        end
        else if (direction_sign == 2'b11) begin
            direction_display <= Right;
        end
    end

endmodule