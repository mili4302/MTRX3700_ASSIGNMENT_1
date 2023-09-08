module CommandStorage (
    input logic [3:0] control_sgin,               // 输入信号，代表所选择的命令方向SW
    input logic clk,                    // 时钟信号
    input logic save_command,           // 控制信号，当为高时，当前命令将被保存到BRAM中
    input logic reset_command,          // 控制信号，当为高时，当前命令地址的内容将被重置
    input logic read_command,           // 控制信号，当为高时，从当前命令地址读取命令
    output logic [7:0] command_counter, // 输出信号，表示当前的命令地址
    output logic [3:0] current_command  // 输出信号，表示从BRAM中读取的当前命令
);

    // 这是BRAM接口的信号
    logic [3:0] data_to_bram;           // 数据输入到BRAM
    logic [3:0] data_from_bram;         // 数据从BRAM输出
    logic rden_bram;                    // 控制信号，当为高时，BRAM将输出数据
    logic wren_bram;                    // 控制信号，当为高时，数据将写入BRAM

    // 使用BRAM硬IP模块
    BRAM_IP bram_ip (
        .address(command_counter),       // 当前的命令地址
        .clock(clk),                     // 时钟信号
        .data(data_to_bram),             // 要写入BRAM的数据
        .rden(rden_bram),                // BRAM的读取控制信号
        .wren(wren_bram),                // BRAM的写入控制信号
        .q(data_from_bram)               // 从BRAM读取的数据
    );

    // 主逻辑块，响应于时钟信号
    always_ff @(posedge clk) begin
        // 当save_command为高时，将命令保存到BRAM中
        if (save_command) begin
            data_to_bram <= motor_control_sgin;  // 将命令转换成四位并且放入data_to_bram的低位
            wren_bram <= 1'b1;            // 激活写入信号
            if (command_counter < 255) begin
                command_counter <= command_counter + 1;  // 更新命令地址
            end
        end 
        // 当read_command为高时，从BRAM的当前地址读取命令
        else if (read_command) begin
            rden_bram <= 1'b1;            // 激活读取信号
        end 
        // 当reset_command为高时，重置BRAM中的当前地址内容
        else if (reset_command) begin
            data_to_bram <= 4'b0000;      // 为BRAM设置零数据
            wren_bram <= 1'b1;            // 激活写入信号
        end 
        // 当没有控制信号激活时，确保BRAM处于非激活状态
        else begin
            wren_bram <= 1'b0;            // 禁用写入信号
            rden_bram <= 1'b0;            // 禁用读取信号
        end
    end
    
    // 输出从BRAM中读取的当前命令
    assign current_command = data_from_bram[3:0];

endmodule
