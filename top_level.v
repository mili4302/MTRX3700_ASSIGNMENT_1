module top_level (
    input       CLOCK_50,
    input   [3:0]   KEY,
    input   [3:0]   SW,
    output  [17:0]  LEDR,
    output  [6:0]   HEX0, HEX1, HEX2, HEX3
);

    debounce key1 (
        .clk(CLOCK_50),
        .button(KEY[1]),
        .button_pressed()
    );

    debounce key2 (
        .clk(CLOCK_50),
        .button(KEY[2]),
        .button_pressed()
    );
    
    debounce key3 (
        .clk(CLOCK_50),
        .button(KEY[3]),
        .button_pressed()
    );

endmodule

