`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2024 07:35:25 PM
// Design Name: 
// Module Name: uart
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


module uart
    #(
     parameter DBIT = 8,        // data width bits
               SB_TICK = 16,    // 16 tick for 1 stop bit
               FIFO_W = 2       // address bits of fifo
    )
    (
     input logic clk, reset, 
     input logic rd_uart, wr_uart, rx,
     input logic [7:0] w_data,
     input logic [10:0] dvsr,
     output logic rx_empty, tx_full, tx,
     output logic [7:0] r_data
    );
    
    // signal declaration
    logic tick, rx_done_tick, tx_done_tick;
    logic tx_fifo_empty, tx_fifo_not_empty;
    logic [7:0] tx_fifo_out, rx_data_out;
    
    // instance
    baud_gen baud_gen_unit(.*);
    
    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit
    (.*, .s_tick(tick), .dout(rx_data_out));
    
    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit
    (.*, .s_tick(tick), .din(tx_fifo_out), .tx_start(tx_fifo_not_empty));
    
    fifo #(.ADDR_WIDTH(FIFO_W), .DATA_WIDTH(DBIT)) fifo_rx_unit
        (.*, .wr(rx_done_tick), .rd(rd_uart), .empty(rx_empty), 
        .w_data(rx_data_out), .full(), .r_data(r_data));
    
    fifo #(.ADDR_WIDTH(FIFO_W), .DATA_WIDTH(DBIT)) fifo_tx_unit
        (.*, .wr(wr_uart), .rd(tx_done_tick), .empty(tx_fifo_empty),
        .w_data(wr_uart), .full(tx_full), .r_data(tx_fifo_out));
    
    assign tx_fifo_not_empty = ~tx_fifo_empty;
endmodule
