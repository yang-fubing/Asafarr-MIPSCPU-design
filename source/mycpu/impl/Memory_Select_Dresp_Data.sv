`include "common.svh"
`include "mycpu/mycpu.svh"

module Memory_Select_Dresp_Data (
    input memory_args_t MemoryArgs,
    input word_t raw_data, 
    
    output word_t data
);

i2 offset;
assign offset = MemoryArgs.addr[1:0];

always_comb begin
    unique case (MemoryArgs.msize)
        MSIZE1: begin
            if (MemoryArgs.sig == UNSIGNED) begin
                unique case (offset)
                    2'b00: data = {{24'b0}, raw_data[7:0]};
                    2'b01: data = {{24'b0}, raw_data[15:8]};
                    2'b10: data = {{24'b0}, raw_data[23:16]};
                    2'b11: data = {{24'b0}, raw_data[31:24]};
                endcase
            end
            else begin
                unique case (offset)
                    2'b00: data = {{24{raw_data[7]}}, raw_data[7:0]};
                    2'b01: data = {{24{raw_data[15]}}, raw_data[15:8]};
                    2'b10: data = {{24{raw_data[23]}}, raw_data[23:16]};
                    2'b11: data = {{24{raw_data[31]}}, raw_data[31:24]};
                endcase
            end
        end
        MSIZE2: begin
            if (MemoryArgs.sig == UNSIGNED) begin
                unique case (offset)
                    2'b00: data = {{16'b0}, raw_data[15:0]};
                    2'b10: data = {{16'b0}, raw_data[31:16]};
                    default: data = 32'h0;
                endcase
            end
            else begin
                unique case (offset)
                    2'b00: data = {{16{raw_data[15]}}, raw_data[15:0]};
                    2'b10: data = {{16{raw_data[31]}}, raw_data[31:16]};
                    default: data = 32'h0;
                endcase
            end
        end
        MSIZE4: begin
            unique case (offset)
                2'b00: data = raw_data;
                default: data = 32'h0;
            endcase
        end
        default: begin
            data = 32'h0;
        end
    endcase
end

endmodule
