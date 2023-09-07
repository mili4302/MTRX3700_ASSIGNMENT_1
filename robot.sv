module robot (
	input [1:0] SW,       // SW[1:0] for direction
	input KEY[3:0],       // KEY[3] to save, KEY[2] to execute, KEY[1] reset
	input clk,			  // On DE2-115 board freq of timer is :50MHZ, 50'000'000 times = 1s
	output reg [3:0] HEX, // 7-segment display outputs
	output reg [17:0] LEDR, // LEDs for torque representation
	output done	,
	output reg [6:0] HEX0, // 
    output reg [6:0] HEX1, // 
    output reg [6:0] HEX2, // 
    output reg [6:0] HEX3  // 
	output [17:0] LEDR                // 18 red LEDs
);
	
    typedef enum [1:0] {IDLE, Programming, Execute, Reset} state_type;
    state_type state, next_state;

	reg [7:0] command_counter = 0; // can count up to 256
	reg [7:0] reset_counter = 0; // Used for resetting the command_array
	reg [1:0] command_array[255:0]; // Array to store commands


	// Next state logic
	always_comb begin 
		unique case (state)
			IDLE:
				if (KEY[1]) next_state = Programming;
				else next_state = IDLE;

			Programming:
				if (KEY[3]) next_state = Programming;
				else if (KEY[2]) next_state = Execute;
				else next_state = Programming;

			Execute:
				if (KEY[1]) next_state = Programming;
				else next_state = Execute;

			Reset:
			    if (reset_counter == 255) next_state = Programming;
            	else next_state = Reset;

		endcase
	end

	// State action and state update logic
	always @(posedge clk or posedge rst) begin
		if (!rst) begin
			state <= IDLE; 
			// TODO: Add other reset logic if necessary
		end
		else begin
			state <= next_state;

			case (state)
				IDLE: 
					// TODO: 等待

				Programming: 
					if (KEY[3]) begin
						command_array[command_counter] = SW;
						if (command_counter < 255)
							command_counter = command_counter + 1;
						else //错误提示
						
					end 

				Execute:
					if (KEY[1]) begin
						// TODO: 清空BRAM
						command_counter <= 8'd0; // Command_counter = 0
						done <= 0; // done = 0
					end else {
						if(SW == 2'b00) // 前
						{
							HEX0 <= 7'b1111111; //
                            HEX1 <= 7'b1111111;
                            HEX2 <= 7'b0001110;
                            HEX3 <= 7'b1111111;
							LEDR <= 18'b0000111100001111
						}
						else if(SW == 2'b01) // 右
						{
							HEX0 <= 7'b0101111; //
                            HEX1 <= 7'b1111111;
                            HEX2 <= 7'b1111111;
                            HEX3 <= 7'b1111111;
							LEDR <= 18'b0000111100001100
						}
						else if(SW == 2'b10)  // 左
						{
							HEX0 <= 7'b1111111; // 
                            HEX1 <= 7'b1000111;
                            HEX2 <= 7'b1111111;
                            HEX3 <= 7'b1111111;
							LEDR <= 18'b0000110000001111
						}
						else if(SW == 2'b11)    // 后
						{
							HEX0 <= 7'b1111111; // 
                            HEX1 <= 7'b1111111;
                            HEX2 <= 7'b1111111;
                            HEX3 <= 7'b0000011;
							LEDR <= 18'b1111000011110000
						}

                	}

					Reset:
						command_array[reset_counter] <= 0;
						reset_counter = reset_counter + 1;	

			endcase
		end
	end


endmodule