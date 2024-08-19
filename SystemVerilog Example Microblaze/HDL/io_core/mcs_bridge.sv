`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2024 10:21:12 PM
// Design Name: 
// Module Name: mcs_bridge
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


module mcs_bridge
    #(parameter BRG_BASE = 32'hc000_0000)
    (
     // mcs i/o
     input logic io_addr_strobe, // not use
     input logic io_read_strobe,
     input logic io_write_strobe,
     input logic [3:0] io_byte_enable, // not use
     input logic [31:0] io_address,
     input logic [31:0] io_write_data,
     output logic [31:0] io_read_data,
     output logic io_ready,
     // FPro bus
     input logic [31:0] fp_rd_data,
     output logic [31:0] fp_wr_data,
     output logic [20:0] fp_addr,
     output logic fp_rd,
     output logic fp_wr,
     output logic fp_mmio_cs
    );
    
    // declaration
    logic bridge_en;
    logic [29:0] word_addr;
    
    // 2 LSB is word aligment
    // address translation and decoding
    assign word_addr = io_address[31:2];
    assign bridge_en = (io_address[31:24] == BRG_BASE[31:0]);
    assign fp_mmio_cs = (bridge_en && (io_address[23]==0));
    assign fp_addr = word_addr[20:0];
    
    // control line conversion
    assign fp_wr = io_write_strobe;
    assign fp_rd = io_read_strobe;
    assign io_ready = 1; // not use; always assert; transaction done in 1 clock
    
    // data line conversion
    assign fp_wr_data = io_write_data;
    assign io_read_data = fp_rd_data;
endmodule
