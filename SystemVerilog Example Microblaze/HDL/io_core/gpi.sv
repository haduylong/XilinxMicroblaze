`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2024 12:30:16 AM
// Design Name: 
// Module Name: gpi
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


module gpi
    #(parameter W=8)
    (
    input logic clk,
    input logic reset,
    // slot interface
    input logic cs,
    input logic read,
    input logic write,
    input logic [4:0] addr,
    input logic [31:0] wr_data,
    output logic [31:0] rd_data,
    // external input signal
    input [W-1:0] din
    );
    
    // declaration
    logic [W-1:0] rd_data_reg;
    
    //
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            rd_data_reg <= 0;
        else
            rd_data_reg <= din;     
    end
    
    //
    assign rd_data[W-1:0] = rd_data_reg;
    assign rd_data[31:W] = 0;
endmodule
