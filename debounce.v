module debounce (
    input clk, button,
    output reg button_pressed
);
  localparam delay_val = 3;

  // Your code here!
  reg [11:0] counts;

  always@(posedge clk)
  begin
    if(button)begin
      if(counts == delay_val)begin
        button_pressed <= 1;
      end
      else begin
        button_pressed <= 0;
      end
      counts <= counts + 1;
    end
    else begin
      counts <= 0;
     end
  end
  
endmodule


