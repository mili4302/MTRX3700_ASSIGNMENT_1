module robot (
	input [1:0] SW,       // SW[1:0] for direction
	input KEY[3:0],       // KEY[3] to save, KEY[2] to execute, KEY[1] reset
	input clk,
	input delay_timer;    // 2s
	output reg [3:0] HEX, // 7-segment display outputs
	output reg [17:0] LEDR, // LEDs for torque representation
	output done	
);
	
    typedef enum [1:0] {IDLE, Programming, Execute} state_type;
    state_type state, next_state;

	reg [7:0] command_counter = 0; // can count up to 256
	reg [1:0] command_array[255:0];


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
						// TODO: 亮灯
                	}

			endcase
		end
	end


endmodule