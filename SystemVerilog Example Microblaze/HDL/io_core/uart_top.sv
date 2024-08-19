`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2024 08:37:55 PM
// Design Name: 
// Module Name: uart_top
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


module uart_top
    #(
     parameter FIFO_DEPTH_BIT = 8 // addr  bit of fifo
    )
    (
     input logic clk, reset,
     // slot interface
     input logic cs,
     input logic write,
     input logic read,
     input logic [4:0] addr,
     input logic [31:0] wr_data,
     output logic [31:0] rd_data,
     // outside signal
     input logic rx,
     output logic tx
    );
    
    // signal declaration
    logic rd_uart, wr_uart, wr_dvsr;
    logic rx_empty, tx_full;
    logic [10:0] dvsr_reg;
    logic [7:0] r_data;
    logic ctrl_reg;
    
    // instance
    uart #(.DBIT(8), .SB_TICK(16), .FIFO_W(FIFO_DEPTH_BIT)) uart_unit
        (.*, .w_data(wr_data[7:0]), .dvsr(dvsr_reg));
        
    // dvsr register
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            dvsr_reg <= 0;
        else
            if(wr_dvsr)
                dvsr_reg <= wr_data[10:0];
    end
    
    // decoding
    assign wr_dvsr = (write && cs && (addr[1:0] == 2'b01));
    assign wr_uart = (write && cs && (addr[1:0] == 2'b10));
    /* don't care write in dummy, care about read data(rd_data) */
    assign rd_uart = (write && cs && (addr[1:0] == 2'b11));
    
    // slot read
    assign rd_data = { 22'h00000, tx_full, rx_empty, r_data};
endmodule
