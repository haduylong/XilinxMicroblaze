`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2024 09:38:03 AM
// Design Name: 
// Module Name: fifo
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


module fifo
    #(parameter ADDR_WIDTH=3, DATA_WIDTH=8)
    (
        input logic clk, reset,
        input logic wr, rd,
        input logic [DATA_WIDTH-1:0] w_data, 
        output logic [DATA_WIDTH-1:0] r_data,
        output logic full, empty        
    );
    // signal declaration
    logic [ADDR_WIDTH-1:0] w_addr, r_addr;
    
    // instance register file
    reg_fifo #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH))
        r_file_unit(.w_en(~full&wr), .*);
    
    // instance fifo controller
    fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH))
        fifo_ctrl_unit(.*);
endmodule
