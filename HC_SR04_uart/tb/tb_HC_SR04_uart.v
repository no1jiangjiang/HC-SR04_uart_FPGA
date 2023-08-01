`timescale 1ns/1ns
module tb_HC_SR04_uart ();

reg sys_clk     ;
reg sys_rst_n   ;
reg echo        ;

wire uart_tx;
wire trig;

parameter T = 20;

always #(T/2) sys_clk = ~sys_clk;

initial begin
    sys_clk <= 1'b0;
    sys_rst_n <= 1'b0;
    echo <= 1'b0;
    #(T*3 + 3)
    sys_rst_n <= 1'b1;
    moni_echo;
    #(3000)
    moni_echo;
    #(200)
    $stop;

end

task moni_echo;
     integer i;
     repeat(20)begin
       i = {$random} % 130;
       #i echo = ~echo;
     end
endtask

HC_SR04_uart HC_SR04_uart_inst(
    /*input   */            .sys_clk       (sys_clk  ),
    /*input   */            .sys_rst_n     (sys_rst_n),
    /*input   */            .echo          (echo     ),

    /*output  */            .trig          (trig),         
    /*output  */            .uart_tx       (uart_tx)
);
endmodule