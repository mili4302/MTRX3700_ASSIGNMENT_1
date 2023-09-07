module robot (
	input [1:0] SW,       // SW[1:0] for direction
	input [3:0] KEY,       // KEY[3] to save, KEY[2] to execute, KEY[1] reset
	input clk,			  // On DE2-115 board freq of timer is :50MHZ, 50'000'000 times = 1s
	output reg [3:0] HEX, // 7-segment display outputs
	output reg [17:0] LEDR, // LEDs for torque representation
	output reg [6:0] HEX0, // 
    output reg [6:0] HEX1, // 
    output reg [6:0] HEX2, // 
    output reg [6:0] HEX3 // 
);
	
    typedef enum logic [3:0] {IDLE = 4'b0000, Programming = 4'b0001, Execute = 4'b0010, Reset = 4'b0100} state_type;
    state_type state, next_state;
	
	reg [7:0] command_counter = 0; // can count up to 256
	reg [7:0] reset_counter = 0; // Used for resetting the command_array
	reg [1:0] command_array[255:0]; // Array to store commands


	// Next state logic
	always_comb begin 
		unique case (state)
			IDLE:begin
				if (KEY[1]) next_state = Programming;
				else next_state = IDLE; 
			end

			Programming:begin
				if (KEY[3]) next_state = Programming;
				else if (KEY[2]) next_state = Execute;
				else next_state = Programming;
			end
				
			Execute: begin
				if (KEY[1]) next_state = Reset;
				else next_state = Execute;
			end

			Reset: begin
			    if (reset_counter == 255) next_state = Programming;
            	else next_state = Reset;
			end

		endcase
	end

	// State action and state update logic
	always_ff @(posedge clk) begin
			state <= next_state;

			case (state)

				Programming: 
						begin
							command_array[command_counter] = SW;
							
							if (command_counter < 255) begin
								command_counter = command_counter + 8'd1;
		
							end
						end 

				Execute:
						begin
							if(SW == 2'b00) begin
								HEX0 <= 7'b1111111;
								HEX1 <= 7'b1111111;
								HEX2 <= 7'b0001110;
								HEX3 <= 7'b1111111;
								LEDR <= 18'b0000111100001111;
							end
							else if(SW == 2'b01) begin
								HEX0 <= 7'b0101111;
								HEX1 <= 7'b1111111;
								HEX2 <= 7'b1111111;
								HEX3 <= 7'b1111111;
								LEDR <= 18'b0000111100001100;
							end
							else if(SW == 2'b10) begin
								HEX0 <= 7'b1111111;
								HEX1 <= 7'b1000111;
								HEX2 <= 7'b1111111;
								HEX3 <= 7'b1111111;
								LEDR <= 18'b0000110000001111;
							end
							else if(SW == 2'b11) begin
								HEX0 <= 7'b1111111;
								HEX1 <= 7'b1111111;
								HEX2 <= 7'b1111111;
								HEX3 <= 7'b0000011;
								LEDR <= 18'b1111000011110000;
							end

							command_counter <= command_counter - 8'd1;
 
						end



                	

				Reset:
				begin
					command_array[reset_counter] <= 0;
					reset_counter = reset_counter + 1;	
				end
			endcase
		end

endmodule