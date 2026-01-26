`timescale 1ns/1ps

module blink_tb;

    // Signals to connect to DUT
    logic btn_0;
    logic led0_b;

    // Instantiate the DUT
    blink dut (
        .btn_0(btn_0),
        .led0_b(led0_b)
    );

   logic clk;
   initial clk = 0;
   
   always #5 clk = ~clk;
   
    
    initial begin
        btn_0 = 1;
        #50;
        btn_0 = 0;
        #50;
        btn_0 = 1;
        #50;    
        $finish;
    end
endmodule
