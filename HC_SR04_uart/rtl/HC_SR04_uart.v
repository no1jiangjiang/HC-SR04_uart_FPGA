module HC_SR04_uart(
    input               sys_clk       ,
    input               sys_rst_n     ,
    input               echo          ,
    input        		uart_rx		  , // 串口输入 

    output              trig          ,         
    output              uart_tx       //串口发送端口
);
wire             clk_us;
wire [18:0]      data_o_r;//待发送的数据
//时钟分频
div_clk_us div_clk_us_inst(
    /*input */      .sys_clk         (sys_clk  ),
    /*input */      .sys_rst_n       (sys_rst_n),

    /*output*/      .clk_us          (clk_us)
);
//产生驱动超声波信号
trig_driver trig_driver_inst(
    /*input */      .sys_us        (clk_us),//1us时钟
    /*input */      .sys_rst_n     (sys_rst_n),

    /*output*/      .trig          (trig)//驱动超声波的信号
);
//对返回来的echo信号进行计算得出距离
echo_driver echo_driver_inst(
    /*input        */   .sys_clk         (sys_clk),
    /*input        */   .sys_us          (clk_us),
    /*input        */   .sys_rst_n       (sys_rst_n),
    /*input        */   .echo            (echo),

    /*output [18:0]*/   .data_o          (data_o_r)//检测距离，保留三位小数，*1000实现
);
//初步想法是使用串口发送模块直接操作，不需要串口回环，否则需要发送到接收，接收模块再发送给发送模块，发送模块再发送给PC
uart_driver2 uart_driver2_inst(
	.clk         (sys_clk  ),
	.rstn        (sys_rst_n),
	.data_in	 (data_o_r	),
    .UART_rx     (uart_rx),

	.UART_tx     (uart_tx	)
);
endmodule