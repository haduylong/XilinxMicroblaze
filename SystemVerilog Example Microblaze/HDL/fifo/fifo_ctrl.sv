module fifo_ctrl
    #(parameter ADDR_WIDTH=3)
    (
       input logic clk, reset,
       input logic wr, rd,
       output logic full, empty,
       output logic [ADDR_WIDTH-1:0] w_addr,
       output logic [ADDR_WIDTH-1:0] r_addr 
    );
    
    logic [ADDR_WIDTH-1:0] rd_ptr, rd_ptr_next;
    logic [ADDR_WIDTH-1:0] wr_ptr, wr_ptr_next;
    
    logic full_next;
    logic empty_next;
    
    always @(posedge clk, posedge reset)
    begin
        if(reset)
        begin
            rd_ptr <= 0;
            wr_ptr <= 0;
            full <= 1'b0;
            empty <= 1'b1;
        end
        else
        begin
            rd_ptr <= rd_ptr_next;
            wr_ptr <= wr_ptr_next;
            full <= full_next;
            empty <= empty_next;
        end
    end
    
    always_comb
    begin
        // defaults
        rd_ptr_next = rd_ptr;
        wr_ptr_next = wr_ptr;
        full_next = full;
        empty_next = empty;
        
        case({wr,rd})
            2'b01: // read
            begin
                if(~empty)
                begin
                    rd_ptr_next = rd_ptr + 1;
                    full_next = 1'b0;
                    if(rd_ptr_next == wr_ptr)
                    begin
                        empty_next = 1'b1;
                    end
                end
            end
            2'b10: // write
            begin
                wr_ptr_next = wr_ptr + 1;
                empty_next = 1'b0;
                if(wr_ptr_next == rd_ptr)
                begin
                    full_next = 1'b1;
                end
            end
            2'b11: // write and read
            begin
                if(empty)
                begin
                    rd_ptr_next = rd_ptr;
                    wr_ptr_next = wr_ptr;
                end
                else
                begin
                    wr_ptr_next = wr_ptr + 1;
                    rd_ptr_next = rd_ptr + 1;
                end
            end
            default: 
            begin
                rd_ptr_next = rd_ptr;
                wr_ptr_next = wr_ptr;
            end
        endcase
    end
    
    assign w_addr = wr_ptr;
    assign r_addr = rd_ptr;
endmodule