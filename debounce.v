module debounce (
    input clk, button,
    output reg button_pressed
);
  localparam delay_val = 2500/*FILL-IN*/; // 50us with clk period 20ns is ____ counts

  // Your code here!
  reg [11:0] counter = 0;
  reg last_button_state = 1'b1; // Assuming the button is initially not pressed

  always @(posedge clk) begin
    if (button != last_button_state) begin // button is pressed
      counter <= counter + 1; // debounce process
    end else begin
      counter <= 0;
    end

    if (counter >= delay_val) begin
      button_pressed <= button;
      last_button_state <= button;
    end
  end
endmodule


