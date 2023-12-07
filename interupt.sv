module interupt (
    input  logic         is_mret,
    input  logic         tm_interupt,
    output logic [31: 0] epc,
    output logic         epc_taken, 
    output logic         excep
);

    logic [31: 0] csr_reg [4];
    logic [31: 0] mcause   = 32'b0;
    logic [31: 0] mtvec    = 32'b0;

    always_comb 
    begin
        if (tm_interupt)
        begin
            csr_reg[0][3] = 1'b1;        
            csr_reg[1][7] = 1'b1;        
            csr_reg[3][7] = 1'b1;        
        end    
    end


    always_comb 
    begin
        if(csr_reg[0][3] & csr_reg[1][7] & csr_reg[3][7])
        begin
            excep = 1'b1;
        end
        else
        begin
            excep = 1'b0;
        end
    end
    
    always_comb
    begin
        if (is_mret)
        begin
            epc_taken = 1'b1;
            epc       = csr_reg[2]; // reading the value of 'mepc' register
        end
        else
        begin
            epc_taken = 1'b0;
        end
    end

endmodule