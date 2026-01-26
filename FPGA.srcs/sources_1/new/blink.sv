`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2026 13:27:41
// Design Name: 
// Module Name: blink
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


module blink(
        input logic btn_0,
        output logic led0_b
    );
    
assign led0_b = btn_0;
endmodule
