module top_level (
    input       CLOCK_50,
    input   [3:1]   KEY,
    input   [3:0]   SW,
    output  [17:0]  LEDR,
    output  [6:0]   HEX0, HEX1, HEX2, HEX3
);
    wire rest_button, execute_button, save_button;
    wire    [1:0]   direction, torque;

    debounce key1 (
        .clk( CLOCK_50 ),
        .button( KEY[1] ),
        .button_pressed( rest_button )
    );

    debounce key2 (
        .clk( CLOCK_50 ),
        .button( KEY[2] ),
        .button_pressed( execute_button )
    );
    
    debounce key3 (
        .clk( CLOCK_50 ),
        .button( KEY[3] ),
        .button_pressed( save_button) 
    );

    FSM u0(
        .control_sgin(SW[3:0]),
        .clk(CLOCK_50),
        .button1(rest_button),
        .button2(execute_button),
        .button3(save_button),
    )

    motor_cotorl mc (
        .clk( CLOCK_50 ),
        .direction( direction ),
        .torque( torque ),
        .right_motor( LEDR[8:0] ),
        .left_motor( LEDR[17:9] )
    );

    display show(
        .clk(CLOCK_50),
        .direction_sign(direction),
        .segments0(HEX0),
        .segments1(HEX1),
        .segments2(HEX2),
        .segments3(HEX3),
    )

endmodule

