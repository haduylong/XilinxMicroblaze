`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2024 11:17:43 PM
// Design Name: 
// Module Name: gpo
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


module gpo
    #(parameter W=8) // width of external output
    (
        input logic clk,
        input logic reset,
        // slot interface
        input logic cs,
        input logic write,
        input logic read,
        input logic [4:0] addr,
        input logic [31:0] wr_data,
        output logic [31:0] rd_data,
        // external output
        output logic [W-1:0] dout
    );
    
    // declaration
    logic [W-1:0] buf_reg;
    logic wr_en;
    
    // output buffer register
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            buf_reg <= 0;
        else
            if(wr_en)
                buf_reg <= wr_data[W-1:0]; 
    end
    
    // decoding logic; enable write
    assign wr_en = (cs && write);
    // slot read interface (0 in GPO)
    assign rd_data = 0;
    // output
    assign dout = buf_reg;
endmodule
