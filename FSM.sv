module FSM (
    input logic [3:0] control_sgin,                // 输入的方向命令
    input logic clk,                     // 时钟信号
    input logic button1, button2, button3               // 输入按键，KEY[3] 用于保存，KEY[2] 用于执行，KEY[1] 用于复位
);

    // 定义状态枚举
    typedef enum logic [3:0] {
        Programming = 4'b0001,          
        Execute = 4'b0010,              
        Run = 4'b0100,                  
        Reset = 4'b1000                 
    } state_type;
    
    state_type state, next_state;       // 当前状态和下一个状态

    // 命令存储模块的标志和输出
    logic save_command, reset_command, read_command;
    logic [1:0] current_command;
    logic [7:0] command_counter;

    reg execute_done = 0;  //判断所有command是否执行完
    logic run_done; //判断run 两秒是否完成
    logic reset_done; //判断reset是否完成
    logic [31:0] run_counter = 32'd0; //run 1e clock cycle
    logic [7:0] reset_bram_counter = 8'd0; //256个cycle

    // 使用CommandStorage模块
    CommandStorage command_storage (
        .control_sgin(SW),
        .clk(clk),
        .save_command(save_command),
        .reset_command(reset_command),
        .read_command(read_command),
        .command_counter(command_counter),
        .current_command(current_command)
    );

    // 状态转换逻辑
    always_comb begin 
        unique case (state)
            Programming: begin
                // 在Programming state,KEY[3] 保存命令,KEY[2] 进入执行状态
                if (button3) next_state = Programming; 
                else if (button2 || command_counter == 255) next_state = Execute;
                else next_state = Programming;
            end
                
            Execute: begin
                // 在Execute state，KEY[1] 进入Reset状态，否则进入运行状态
                if (button1 || execute_done == 1) next_state = Reset; 
                else next_state = Run;
            end

            Run: begin
                // 在Run state，根据current_command决定下一步操作
                if (run_done) next_state = Execute;  // 当计时完成后，进入Programming状态
                else next_state = Run; 
            end

            Reset: begin
                if (reset_done) next_state = Programming;  // 当BRAM清空完成后，进入Programming状态
                else next_state = Reset;
            end
        endcase
    end

    // 状态动作和状态更新逻辑
    always_ff @(posedge clk) begin
        state <= next_state;

        case (state)
            Programming: begin
                // 在编程状态下，激活保存命令标志
                save_command <= 1'b1; 
                reset_command <= 1'b0;
                read_command <= 1'b0;
            end 

            Execute: begin
                // TODO: 亮灯
                    if (command_counter > 0) 
                    command_counter <= command_counter - 8'd1;
					else execute_done <= 1;

                // 根据current_command设置HEX和LEDR的输出值...
            end

            Run: begin
                if (run_counter < 32'd100000000) begin
                    run_counter = run_counter + 32'd1; // 计数器增加，直到达到1亿
                end
                else begin
                    run_done = 1'b1;   // 设置delay_done标志
                    run_counter = 32'd0;   // 重置计数器
                end
            end

            Reset: begin
                save_command <= 1'b0;
                reset_command <= 1'b1;  // 激活reset_command，以清空BRAM中的当前地址
                read_command <= 1'b0;

                if (reset_bram_counter < 255) begin
                    reset_bram_counter = reset_bram_counter + 8'd1;  // 更新BRAM地址
                end
                else begin
                    reset_done = 1'b1;  // 设置reset_done标志
                    reset_bram_counter = 8'd0;  // 重置BRAM地址计数器
                end
            end
        endcase
    end

endmodule
