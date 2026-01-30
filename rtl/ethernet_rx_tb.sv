`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2026 14:06:05
// Design Name: 
// Module Name: ethernet_rx_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ethernet_rx_tb;
    // DUT inputs
    logic eth_rx_clk;
    logic eth_rx_dv;
    logic eth_rxerr;
    logic [3:0]  eth_rxd;

    // DUT outputs
    logic [7:0] rx_byte;
    logic rx_byte_valid;

    // Instantiate DUT
    ethernet_rx dut (
        .eth_rx_clk(eth_rx_clk),
        .eth_rx_dv(eth_rx_dv),
        .eth_rxerr(eth_rxerr),
        .eth_rxd(eth_rxd),
        .rx_byte(rx_byte),
        .rx_byte_valid(rx_byte_valid)
    );

    // clock
    initial eth_rx_clk = 0;
    always #20 eth_rx_clk = ~eth_rx_clk;
    
    task send_byte(input [7:0] b);
        begin
            eth_rxd <= b[3:0];
            @(posedge eth_rx_clk);
            
            eth_rxd <= b[7:4];
            @(posedge eth_rx_clk);
        end
    endtask
    
    initial begin
        eth_rx_dv  = 0;
        eth_rxerr = 0;
        eth_rxd   = 4'h0;
        
        repeat (5) @(posedge eth_rx_clk);
        eth_rx_dv = 1;
        repeat (7) send_byte(8'h55);
        send_byte(8'hD5);
        
        send_byte(8'hE1);
        send_byte(8'h11);
        send_byte(8'hE5);
        
        eth_rx_dv = 0;
        eth_rxd   = 4'h0;
        repeat (5) @(posedge eth_rx_clk);
        $finish;
    end
    
endmodule
