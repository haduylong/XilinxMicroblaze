`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2024 02:59:23 PM
// Design Name: 
// Module Name: mmio_controller
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


module mmio_controller
    (
     // FPro bus
     input logic clk,
     input logic reset,
     input logic mmio_cs,
     input logic mmio_wr,
     input logic mmio_rd,
     input logic [20:0] mmio_addr,
     input logic [31:0] mmio_wr_data,
     output logic [31:0] mmio_rd_data,
     // array of slot interface
     output logic [63:0] slot_cs_array,
     output logic [63:0] slot_mem_wr_array,
     output logic [63:0] slot_mem_rd_array,
     output logic [4:0] slot_reg_addr_array [63:0],
     output logic [31:0] slot_wr_data_array [63:0],
     input logic [31:0] slot_rd_data_array [63:0]
    );
    
    // declaration
    logic [5:0] slot_addr;
    logic [4:0] reg_addr;
    
    // address decoding
    assign slot_addr = mmio_addr[10:5];
    assign reg_addr = mmio_addr[4:0];
    
    always_comb
    begin
        slot_cs_array = 0;
        if(mmio_cs)
            slot_cs_array[slot_addr] = 1;
    end
    
    // address multiplexing
    assign mmio_rd_data = slot_rd_data_array[slot_addr];
    
    // boardcast to all slot
    generate
        genvar i;
        for(i=0; i<64; i=i+1)
        begin
            assign slot_mem_wr_array[i] = mmio_wr;
            assign slot_mem_rd_array[i] = mmio_rd;
            assign slot_wr_data_array[i] = mmio_wr_data;
            assign slot_reg_addr_array[i] = reg_addr;
        end
    endgenerate
endmodule
