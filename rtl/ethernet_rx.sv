`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2026 13:24:53
// Design Name: 
// Module Name: ethernet_rx
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


module ethernet_rx(
        input logic eth_rx_clk,
        input logic eth_rx_dv,
        input logic eth_rxerr,
        input logic [3:0] eth_rxd,

        output logic [7:0] rx_byte,
        output logic rx_byte_valid
    );
    
     typedef enum logic [1:0] {
        IDLE,
        PREAMBLE,
        DATA
    } rx_state_t;

    rx_state_t state;

    logic nibble_phase;   // 0 = low nibble, 1 = high nibble
    logic [3:0] nibble_store;
    logic drop_frame;
    
    always_ff @(posedge eth_rx_clk) begin
        rx_byte_valid <= 1'b0;

        if (!eth_rx_dv) begin
            state <= IDLE;
            nibble_phase <= 1'b0;
            drop_frame <= 1'b0;
        end
        else begin
            // frame is being sent

            if (eth_rxerr) begin
                drop_frame <= 1'b1;
            end

            // nibble to byte (LSB first)
            if (!nibble_phase) begin
                nibble_store <= eth_rxd;
                nibble_phase <= 1'b1;
            end
            else begin
                logic [7:0] full_byte = {eth_rxd, nibble_store};
                rx_byte <= full_byte;
                nibble_phase <= 1'b0;

                // full byte has been received
                case (state)
                    IDLE: begin
                        // first byte should be preamble
                        state <= PREAMBLE;
                    end

                    PREAMBLE: begin
                        if (full_byte == 8'h55) begin
                            // 0x55 means preamble, do nothing
                        end
                        else if (full_byte == 8'hD5) begin
                            // start frame delimiter (0xD5)
                            state <= DATA;
                        end
                        else begin
                            // preamble is invlaid, should drop frame
                            drop_frame <= 1'b1;
                        end
                    end

                    DATA: begin
                        if (!drop_frame) begin
                            rx_byte <= full_byte;
                            rx_byte_valid <= 1'b1;
                        end
                    end
                endcase
            end
        end
    end
    
endmodule
