module motor_control (
    input   clk,
    input   [1:0]   direction,
    input   [1:0]   torque,
    output  [7:0]   right_motor, left_motor
);
    always_ff @(posedge clk) begin
        case (direction)
            // Forward
            2'b00:begin
                right_motor <= (torque == 2'b00) ? 8'b00000000 :
                               (torque == 2'b01) ? 8'b00001000 :
                               (torque == 2'b10) ? 8'b00001100 : 8'b00001111;
                               
                left_motor <= (torque == 2'b00) ? 8'b00000000 :
                              (torque == 2'b01) ? 8'b00001000 :
                              (torque == 2'b10) ? 8'b00001100 : 8'b00001111;
            end
            // Right
            2'b01:begin
                right_motor <= (torque == 2'b00) ? 8'b00000000 :
                               (torque == 2'b01) ? 8'b00000000 :
                               (torque == 2'b10) ? 8'b00001000 : 8'b00001100;

                left_motor <= (torque == 2'b00) ? 8'b00000000 :
                              (torque == 2'b01) ? 8'b00001000 :
                              (torque == 2'b10) ? 8'b00001100 : 8'b00001111;
            end
            // Left
            2'b10:begin
                right_motor <= (torque == 2'b00) ? 8'b00000000 :
                               (torque == 2'b01) ? 8'b00001000 :
                               (torque == 2'b10) ? 8'b00001100 : 8'b00001111;

                left_motor <= (torque == 2'b00) ? 8'b00000000 :
                               (torque == 2'b01) ? 8'b00000000 :
                               (torque == 2'b10) ? 8'b00001000 : 8'b00001100;
            end
            // Reverse
            2'b11:begin
                right_motor <= (torque == 2'b00) ? 8'b00000000 :
                               (torque == 2'b01) ? 8'b00010000 :
                               (torque == 2'b10) ? 8'b00110000 : 8'b11110000;

                left_motor <= (torque == 2'b00) ? 8'b00000000 :
                              (torque == 2'b01) ? 8'b00010000 :
                              (torque == 2'b10) ? 8'b00011000 : 8'b11110000;
            end
        endcase
    end
endmodule