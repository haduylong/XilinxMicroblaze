`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2024 03:51:30 PM
// Design Name: 
// Module Name: mmio_sys
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

`include "io_map.vh"
module mmio_sys
   #(
     parameter N_SW = 10,
     parameter N_LED = 10, 
     parameter N_PWM = 6,
     parameter S = 1 // slave
    )
    (
     input logic clk,
     input logic reset,
     // FPro bus
     input logic mmio_cs,
     input logic mmio_rd,
     input logic mmio_wr,
     input logic [20:0] mmio_addr,
     input logic [31:0] mmio_wr_data,
     output logic [31:0] mmio_rd_data,
     // switch
     input logic [N_SW-1:0] sw,
     // led
     output logic [N_LED-1:0] led,
     // uart
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
    
    // declaration
    logic [63:0] cs_array;
    logic [63:0] mem_wr_array;
    logic [63:0] mem_rd_array;
    logic [4:0] reg_addr_array [63:0];
    logic [31:0] wr_data_array [63:0];
    logic [31:0] rd_data_array [63:0];
    
    // mmio controller instance
    mmio_controller mmio_controller_unit
    (
     .clk(clk),
     .reset(reset),
     // FPro bus
     .mmio_cs(mmio_cs),
     .mmio_wr(mmio_rd),
     .mmio_rd(mmio_wr),
     .mmio_addr(mmio_addr),
     .mmio_wr_data(mmio_wr_data),
     .mmio_rd_data(mmio_rd_data),
     // array of slot interface
     .slot_cs_array(cs_array),
     .slot_mem_wr_array(mem_wr_array),
     .slot_mem_rd_array(mem_rd_array),
     .slot_reg_addr_array(reg_addr_array),
     .slot_wr_data_array(wr_data_array),
     .slot_rd_data_array(rd_data_array)
    );
    
    // slot 0: timer
    timer timer_unit
    (
     .clk(clk),
     .reset(reset),
     // slot interface
     .cs(cs_array[`S0_SYS_TIMER]),
     .read(mem_rd_array[`S0_SYS_TIMER]),
     .write(mem_wr_array[`S0_SYS_TIMER]),
     .addr(reg_addr_array[`S0_SYS_TIMER]),
     .wr_data(wr_data_array[`S0_SYS_TIMER]),
     .rd_data(rd_data_array[`S0_SYS_TIMER])
    );
    
    // slot 1: uart
    uart_top #(.FIFO_DEPTH_BIT(4)) uart_top_unit
    (
     .clk(clk),
     .reset(reset),
     // slot interface
     .cs(cs_array[`S1_UART1]),
     .read(mem_rd_array[`S1_UART1]),
     .write(mem_wr_array[`S1_UART1]),
     .addr(reg_addr_array[`S1_UART1]),
     .wr_data(wr_data_array[`S1_UART1]),
     .rd_data(rd_data_array[`S1_UART1]),
     // outside signal
     .rx(rx),
     .tx(tx)
    );
    
    // slot 2: gpo; led
    gpo #(.W(N_LED)) gpo_unit
    (
     .clk(clk),
     .reset(reset),
     // slot interface
     .cs(cs_array[`S2_LED]),
     .read(mem_rd_array[`S2_LED]),
     .write(mem_wr_array[`S2_LED]),
     .addr(reg_addr_array[`S2_LED]),
     .wr_data(wr_data_array[`S2_LED]),
     .rd_data(rd_data_array[`S2_LED]),
     // external output signal
     .dout(led)
    );
    
    // slot 3: gpi; switch
    gpi #(.W(N_SW)) gpi_unit
    (
     .clk(clk),
     .reset(reset),
     // slot interface
     .cs(cs_array[`S3_SW]),
     .read(mem_rd_array[`S3_SW]),
     .write(mem_wr_array[`S3_SW]),
     .addr(reg_addr_array[`S3_SW]),
     .wr_data(wr_data_array[`S3_SW]),
     .rd_data(rd_data_array[`S3_SW]),
     // external input signal
     .din(sw)
    );
    
    // slot 4: PWM
    io_pwm_core #(.W(N_PWM), .R(10)) pwm_unit
    (
     .clk(clk),
     .reset(reset),
     // slot interface
     .cs(cs_array[`s4_PWM]),
     .read(mem_rd_array[`s4_PWM]),
     .write(mem_wr_array[`s4_PWM]),
     .addr(reg_addr_array[`s4_PWM]),
     .wr_data(wr_data_array[`s4_PWM]),
     .rd_data(rd_data_array[`s4_PWM]),
     // external output
     .pwm_out(pwm)
    );
    
    // slot 5: spi
    spi_core #(.S(S)) spit_core_unit
    (
     .clk(clk),
     .reset(reset),
     // slot interface
     .cs(cs_array[`s5_SPI]),
     .read(mem_rd_array[`s5_SPI]),
     .write(mem_wr_array[`s5_SPI]),
     .addr(reg_addr_array[`s5_SPI]),
     .wr_data(wr_data_array[`s5_SPI]),
     .rd_data(rd_data_array[`s5_SPI]),
     // external
     .spi_sclk(spi_sclk),
     .spi_miso(spi_miso),
     .spi_mosi(spi_mosi),
     .spi_ss_n(spi_ss_n)
    );
    
    // assign 0's to unused slot rd_data
    generate
        genvar i;
        for(i=6; i<64; i=i+1) begin: unused_slot_gen
              assign rd_data_array[i] = 32'hffff_ffff;         
        end
    endgenerate
endmodule
