module Branch_comp(
    input  logic [ 2:0] br_type,
    input  logic [31:0] opr_a,
    input  logic [31:0] opr_b,
    output logic        br_taken
);
 

always_comb 
begin
    if((br_type == 3'b000) && ($signed(opr_a) == $signed(opr_b)))          //BEQ
        br_taken = 1'b1;
    else if((br_type == 3'b001) && ($signed(opr_a) != $signed(opr_b)))     //BNE
        br_taken = 1'b1;
    else if((br_type == 3'b010) && ($signed(opr_a) < $signed(opr_b)))      //BLT
        br_taken = 1'b1;
    else if((br_type == 3'b100) && (opr_a) < (opr_b))                      //BLTU
        br_taken = 1'b1;
    else if ((br_type == 3'b011) && ($signed(opr_a) >= $signed(opr_b)))    //BGE
        br_taken = 1'b1;
    else if ((br_type == 3'b101) && (opr_a) >= (opr_b))                    //BGEU
        br_taken = 1'b1;
    else
        br_taken = 1'b0;
        
end

endmodule