module inst_decode (
    input  logic [31:0] inst,
    output logic [ 4:0] rd,
    output logic [ 4:0] rs1,
    output logic [ 4:0] rs2,
    output logic [ 6:0] opcode,
    output logic [ 2:0] func3,
    output logic [ 6:0] func7
);
    // TO CONTROL UNIT
    assign opcode  = inst[  6:0];
    assign func3   = inst[14:12];
    assign func7   = inst[31:25];
    
    // TO REGISTER FILE
    assign rd      = inst[ 11:7];
    assign rs1     = inst[19:15];
    assign rs2     = inst[24:20];
    
endmodule