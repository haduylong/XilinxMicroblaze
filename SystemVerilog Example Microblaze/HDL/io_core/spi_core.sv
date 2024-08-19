`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2024 11:49:07 PM
// Design Name: 
// Module Name: spi_core
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


module spi_core
    #(parameter S = 2) // bit width; input port
    (
     input logic clk, reset,
     // slot interface
     input logic cs,
     input logic read,
     input logic write,
     input logic [4:0] addr,
     input logic [31:0] wr_data,
     output logic [31:0] rd_data,
     // external
     input logic spi_sclk,
     input logic spi_miso,
     output logic spi_mosi,
     output logic [S-1:0] spi_ss_n
    );
    
    // signal declaration
    logic wr_en, wr_ss, wr_spi, wr_ctrl;
    logic [17:0] ctrl_reg;
    logic [S-1:0] ss_n_reg;
    logic [7:0] spi_out;
    logic spi_ready, cpol, cpha;
    logic [15:0] dvsr;
    
    // instance spi cintroller
    spi spi_unit
    (
     .clk(clk), .reset(reset),
     .din(wr_data[7:0]),
     .dvsr(dvsr),
     .start(wr_spi),
     .cpol(cpol),
     .cpha(cpha),
     .dout(spi_out),
     .sclk(spi_sclk),
     .miso(spi_miso),
     .mosi(spi_mosi),
     .spi_done_tick(),
     .ready(spi_ready)
    );
    
    // register
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset) begin
            ctrl_reg <= 17'h0_0200;
            ss_n_reg <= {S{1'b1}};
        end
        else begin
            if(wr_ctrl)
                ctrl_reg <= wr_data[17:0];
            if(wr_ss)
                ss_n_reg <= wr_data[S-1:0];
        end
    end
    
    // decoding
    assign wr_en = cs && write;
    assign wr_ss = wr_en && (addr[1:0] == 2'b01);
    assign wr_spi = wr_en && (addr[1:0] == 2'b10);
    assign wr_ctrl = wr_en && (addr[1:0] == 2'b11);
    
    // control signal
    assign dvsr = ctrl_reg[15:0];
    assign cpol = ctrl_reg[16];
    assign cpha = ctrl_reg[17];
    assign spi_ss_n = ss_n_reg;
    
    // read multiplexing
    assign rd_data = {23'b0, spi_ready, spi_out};
endmodule
