module inst_mem (
    input  logic [31:0] addr,
    output logic [31:0] data
);
    
    logic [31:0] mem [0:99];
    always_comb 
    begin 
        data = mem[addr[31:2]];    
    end
    
endmodule