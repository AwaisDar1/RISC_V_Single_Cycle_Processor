module data_mem
(
    input  logic        clk, 
    input  logic        rd_en, 
    input  logic        wr_en,
	input  logic [ 2:0] mem_type,
	input  logic [31:0] addr,
	input  logic [31:0] wdata,
	output logic [31:0] rdata
);

	logic [31:0] data_mem [31:0];  //2D Array
	
	//Instantiating the data memory
	initial begin 
		$readmemb("d_m.mem", data_mem);
	end

    always_ff @(posedge clk)
    begin  
        if(wr_en)
        begin
        case(mem_type)
            3'b000: 
            begin
                data_mem[addr] <= wdata[7:0];
            end
            3'b001: 
            begin
                data_mem[addr] <= wdata[7:0];
                data_mem[addr+1] <= wdata[15:8];
            end
            3'b010:
            begin
                data_mem[addr] <= wdata[7:0];
                data_mem[addr+1] <= wdata[15:8];
                data_mem[addr+2] <= wdata[23:16];
                data_mem[addr+3] <= wdata[31:24];
            end
        endcase
        end
    end

    //Asynchronuous Read
    always@(*)
    begin
        if(rd_en)
        begin
        case(mem_type)
            3'b000:
            begin
                    rdata <= $signed(data_mem[addr]);
            end
            3'b001:
            begin
                    rdata <= $signed({data_mem[addr+1], data_mem[addr]});
            end
            3'b010:
            begin
                    rdata <= $signed({data_mem[addr+3], data_mem[addr+2], data_mem[addr+1], data_mem[addr]});
            end
            3'b011:
            begin
                    rdata <= (data_mem[addr]);
            end
            3'b100:
            begin
                    rdata <= ({data_mem[addr+1], data_mem[addr]});
            end
        endcase
        end
    end  

    final
    begin
        $writememb("d_m.mem", dut.data_mem_i.data_mem);
    end

	
endmodule