`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2024 10:12:33 PM
// Design Name: 
// Module Name: io_pwm_core
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


module io_pwm_core
    #(parameter W = 6, // bit width of output port
                R = 10 // bits of PWM resolution
    )
    (
     input logic clk, reset,
     // slot inteface
     input logic cs,
     input logic read,
     input logic write,
     input logic [4:0] addr,
     input logic [31:0] wr_data,
     output logic [31:0] rd_data,
     // outside
     output [W-1:0] pwm_out 
    );
    
    // signal declaration
    logic [R:0] duty_2d_reg [W-1:0];
    logic duty_array_en, dvsr_en;
    logic [31:0] q_reg, q_next;
    logic [R-1:0] d_reg, d_next;
    logic [R:0] d_ext;
    logic [W-1:0] pwm_reg, pwm_next;
    logic tick;
    logic [31:0] dvsr_reg;
    
    /*************************************************************
    *wrapping cirsuit
    **************************************************************/
    // decodeing
    assign duty_array_en = write && cs && addr[4];
    assign dvsr_en = write && cs && 5'b00000;
    // register for dvsr
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
        begin
            dvsr_reg <= 0;
        end
        else
            if(dvsr_en)
                dvsr_reg <= wr_data;
    end
    // registor for duty cycle
    always_ff @(posedge clk)
    begin
        if(duty_array_en)
            duty_2d_reg[addr[3:0]] <= wr_data[R:0];
    end
    
    /**************************************************************
    * PWM
    ***************************************************************/
    // registor
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
        begin
            q_reg <= 0;
            d_reg <= 0;
            pwm_reg <= 0;
        end
        else
        begin
            q_reg <= q_next;
            d_reg <= d_next;
            pwm_reg <= pwm_next;
        end
    end
    
    // next state logic
    // prescale counter
    assign q_next = (q_reg == dvsr_reg)?0:q_reg + 1'b1;
    assign tick = (q_reg == 0);
    // duty cycle counter
    assign d_next = (tick)?d_reg + 1'b1:d_reg;
    assign d_ext = {1'b0, d_reg};
    // comparation circuit
    generate
        genvar i;
        for(i=0; i<W; i=i+1) begin
            assign pwm_next = pwm_reg < duty_2d_reg[i];
        end
    endgenerate
    // output
    assign pwm_out = pwm_reg;
endmodule
