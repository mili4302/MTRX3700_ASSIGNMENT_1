module motor_control (
    input   clk,
    input   [1:0]   direction,
    input   [1:0]   torque
    output  [8:0]   right_motor, left_motor
);
    always_ff @(posedge clk) begin
        case (direction)
            // Forward
            2'b00:begin
                right_motor <= (torque == 2'b00) ? 00000000 :
                               (torque == 2'b01) ? 00001000 :
                               (torque == 2'b10) ? 00001100 : 00001111;
                               
                left_motor <= (torque == 2'b00) ? 00000000 :
                              (torque == 2'b01) ? 00001000 :
                              (torque == 2'b10) ? 00001100 : 00001111;
            end
            // Right
            2'b01:begin
                right_motor <= (torque == 2'b00) ? 00000000 :
                               (torque == 2'b01) ? 00000000 :
                               (torque == 2'b10) ? 00001000 : 00001100;

                left_motor <= (torque == 2'b00) ? 00000000 :
                              (torque == 2'b01) ? 00001000 :
                              (torque == 2'b10) ? 00001100 : 00001111;
            end
            // Left
            2'b10:begin
                right_motor <= (torque == 2'b00) ? 00000000 :
                               (torque == 2'b01) ? 00001000 :
                               (torque == 2'b10) ? 00001100 : 00001111;

                left_motorr <= (torque == 2'b00) ? 00000000 :
                               (torque == 2'b01) ? 00000000 :
                               (torque == 2'b10) ? 00001000 : 00001100;
            end
            // Reverse
            2'b11:begin
                right_motor <= (torque == 2'b00) ? 00000000 :
                               (torque == 2'b01) ? 00010000 :
                               (torque == 2'b10) ? 00110000 : 11110000;

                left_motor <= (torque == 2'b00) ? 00000000 :
                              (torque == 2'b01) ? 00010000 :
                              (torque == 2'b10) ? 00011000 : 11110000;
            end
        endcase
    end
endmodule