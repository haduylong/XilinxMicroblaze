`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2024 07:38:08 PM
// Design Name: 
// Module Name: hsp_sys_top
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


module hsp_sys_top
    #(
      parameter BRG_BASE = 32'hc000_0000,
      parameter N_SW = 10,
      parameter N_LED = 10,
      parameter N_PWM = 6,
      parameter S = 1 // slave
     )
    (
        input logic clk,
        input logic reset_n,
        // switch and led
        input logic [N_SW-1:0] SW,
        output logic [N_LED-1:0] LED,
        // uart1
        input logic rx,
        output logic tx,
        // PWM
        output logic [N_PWM-1:0] pwm,
        // SPI
        input logic spi_sclk,
        input logic spi_miso,
        output logic spi_mosi,
        output logic [S-1:0] spi_ss_n
    );
    
    // declare signal
    logic clk_100M;
    logic reset_sys;
    
    // MCS I/O bus
    logic io_addr_strobe;
    logic io_read_strobe;
    logic io_write_strobe;
    logic [3:0] io_byte_enable;
    logic [31:0] io_address;
    logic [31:0] io_write_data;
    logic [31:0] io_read_data;
    logic io_ready;
    
    // FPro Bus
    logic [31:0] fp_rd_data;
    logic [31:0] fp_wr_data;
    logic [20:0] fp_addr;
    logic fp_rd;
    logic fp_wr;
    logic fp_mmio_cs;
    
    // system clock, reset
    assign clk_100M = clk; 
    assign reset_sys = ~reset_n;
    // cpu
    cpu cpu_unit (
      .Clk(clk_100M),                          // input wire Clk
      .Reset(reset_sys),                      // input wire Reset
      .IO_addr_strobe(io_addr_strobe),    // output wire IO_addr_strobe
      .IO_address(io_address),            // output wire [31 : 0] IO_address
      .IO_byte_enable(io_byte_enable),    // output wire [3 : 0] IO_byte_enable
      .IO_read_data(io_read_data),        // input wire [31 : 0] IO_read_data
      .IO_read_strobe(io_read_strobe),    // output wire IO_read_strobe
      .IO_ready(io_ready),                // input wire IO_ready
      .IO_write_data(io_write_data),      // output wire [31 : 0] IO_write_data
      .IO_write_strobe(io_write_strobe)  // output wire IO_write_strobe
    );
    
    mcs_bridge #(.BRG_BASE(BRG_BASE)) mcs_bridge_unit
    (
     .io_address(io_address),
     .*
    );
    
    mmio_sys #(.N_SW(N_SW), .N_LED(N_LED)) mmio_sys_unit
    (
     .clk(clk_100M),
     .reset(reset_sys),
     // FPro bus
     .mmio_cs(fp_mmio_cs),
     .mmio_rd(fp_rd),
     .mmio_wr(fp_wr),
     .mmio_addr(fp_addr),
     .mmio_wr_data(fp_wr_data),
     .mmio_rd_data(fp_rd_data),
     // switch and led
     .sw(SW),
     .led(LED),
     // uart1
     .rx(rx),
     .tx(tx),
     // PWM
     .pwm(pwm),
     // SPI
     .spi_sclk(spi_sclk),
     .spi_miso(spi_miso),
     .spi_mosi(spi_mosi),
     .spi_ss_n(spi_ss_n)
    );
endmodule
