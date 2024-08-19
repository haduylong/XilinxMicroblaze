`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2024 10:37:12 AM
// Design Name: 
// Module Name: timer
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


module timer
    (
     input logic clk,
     input logic reset,
     // slot interface
     input logic cs,
     input logic read,
     input logic write,
     input logic [4:0] addr,
     input logic [31:0] wr_data,
     output logic [31:0] rd_data
    );
    
    // declaration
    logic [47:0] count_reg;
    logic ctrl_reg;
    logic wr_en, clear, go;
    
    //****************************************
    // custom logic circuit: counter
    //****************************************
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            count_reg <= 0;
        else
            if(clear)
                count_reg <= 0;
            else if(go)
                count_reg <= count_reg + 1;   
    end
    
    //****************************************
    // wrapping circuit; 
    //****************************************
    // control register
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            ctrl_reg <= 0;
        else
            if(wr_en)
                ctrl_reg <= wr_data[0];
    end
    
    // decoding
    assign wr_en = write && cs && (addr[1:0]==2'b10);
    assign clear = wr_en && wr_data[1];
    assign go = ctrl_reg;
    
    // slot read interface (slave to master)
    assign rd_data = (addr[0]==0)?
                        count_reg[31:0]:
                        {16'h0000, count_reg[47:32]};
endmodule
