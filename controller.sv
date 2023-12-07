module controller
(
    input  logic        br_taken,
    input  logic [6:0]    opcode,
    input  logic [6:0]     func7,
    input  logic [2:0]     func3,
    output logic           rf_en,
    output logic           rd_en,
    output logic           wr_en,
    output logic       sel_opr_a,
    output logic       sel_opr_b,
    output logic          sel_pc,
    output logic [3:0]     aluop,
    output logic [2:0]   br_type,
    output logic [2:0]  mem_type,
    output logic [1:0]    sel_wb,
    output logic [2:0]  imm_type,
    output logic          csr_rd,   // control signal to read from csr register file
    output logic          csr_wr,   // control signal to write to csr register
    output logic          is_mret   // control signal for 'mret' instruction --- 1 will indicate that the inst is mret
);
    always_comb
    begin
        case(opcode)
            7'b0110011: //R-Type
            begin

                rf_en = 1'b1;
                rd_en = 1'b0;
                wr_en = 1'b0;
                
                // mux controls
                sel_opr_a = 1'b0;
                sel_opr_b = 1'b0;
                sel_pc    = 1'b0;
                sel_wb    = 2'b00;

                // immediate controls
                imm_type  = 3'b000;


                case(func3)
                    3'b000: 
                    begin
                        case(func7)
                            7'b0000000: aluop = 4'b0000; //ADD
                            7'b0100000: aluop = 4'b0001; //SUB
                        endcase
                    end
                    3'b001: aluop = 4'b0010;             //SLL
                    3'b010: aluop = 4'b0011;             //SLT
                    3'b011: aluop = 4'b0100;             //SLTU
                    3'b100: aluop = 4'b0101;             //XOR
                    3'b101:
                    begin
                        case(func7)
                            7'b0000000: aluop = 4'b0110; //SRL
                            7'b0100000: aluop = 4'b0111; //SRA
                        endcase
                    end
                    3'b110: aluop = 4'b1000;             //OR
                    3'b111: aluop = 4'b1001;             //AND
                endcase
            end

            7'b0010011: //I-Type
            begin
                rf_en = 1'b1;
                rd_en = 1'b0;
                wr_en = 1'b0;
                // mux controls
                sel_opr_a = 1'b0;
                sel_opr_b = 1'b1;
                sel_pc    = 1'b0;
                sel_wb    = 2'b00;

                // immediate controls
                imm_type  = 3'b000;


                case (func3)
                    3'b000: aluop = 4'b0000;             //ADDI
                    3'b001: aluop = 4'b0010;             //SLLI
                    3'b010: aluop = 4'b0011;             //SLTI
                    3'b011: aluop = 4'b0100;             //SLTUI
                    3'b100: aluop = 4'b0101;             //XORI
                    3'b101:
                    begin
                        case (func7)
                            7'b0000000: aluop = 4'b0110; //SRL
                            7'b0100000: aluop = 4'b0111; //SRA
                        endcase    
                    end
                    3'b110: aluop = 4'b1000;             //ORI
                    3'b111: aluop = 4'b1001;             //ANDI

                    
                endcase
            end

            // I-Type Jump
            7'b1100111:
            begin
                // memory controls
                rf_en = 1'b1;
                rd_en = 1'b0;
                wr_en = 1'b0;
                
                // mux controls
                sel_opr_a = 1'b0;
                sel_opr_b = 1'b1;
                sel_pc    = 1'b1;
                sel_wb    = 2'b10;

                // immediate controls
                imm_type  = 3'b000;

                // operation controls
                aluop = 4'b0000; // add
            end
            // S-type
            7'b0100011: // S-type
            begin
                // memory controls
                rf_en = 1'b0;
                rd_en = 1'b0;
                wr_en = 1'b1;

                // mux controls
                sel_opr_a = 1'b0;
                sel_opr_b = 1'b1;
                sel_pc    = 1'b0;
                sel_wb    = 2'b11;

                // immediate controls
                imm_type  = 3'b100;

                // operation controls
                aluop = 4'b0000; // add
                case (func3)
                3'b000: mem_type = 3'b000;
                3'b001: mem_type = 3'b001;
                3'b010: mem_type = 3'b010;
                endcase

            end
            // L-type
            7'b0000011: // L-type
            begin
                // memory controls
                rf_en = 1'b1;
                rd_en = 1'b1;
                wr_en = 1'b0;

                // mux controls
                sel_opr_a = 1'b0;
                sel_opr_b = 1'b1;
                sel_pc    = 1'b0;
                sel_wb    = 2'b01;

                // immediate controls
                imm_type  = 3'b000;

                // operation controls
                aluop = 4'b0000; // add
                case (func3)
                3'b000: mem_type = 3'b000;
                3'b001: mem_type = 3'b001;
                3'b010: mem_type = 3'b010;
                3'b100: mem_type = 3'b011;
                3'b101: mem_type = 3'b100;
                endcase

            end

            // J-Type
            7'b1101111: // J-Type
            begin
                // memory controls
                rf_en = 1'b1;
                rd_en = 1'b0;
                wr_en = 1'b0;

                // mux controls
                sel_opr_a = 1'b1;
                sel_opr_b = 1'b1;
                sel_pc    = 1'b1;
                sel_wb    = 2'b10;

                // immediate controls
                imm_type  = 3'b001;

                // operation controls
                aluop = 4'b0000; // add
            end
            // LUI-Type
            7'b0110111: // U-Type
            begin
                // memory controls
                rf_en = 1'b1;
                rd_en = 1'b0;
                wr_en = 1'b0;

                // mux controls
                sel_opr_a = 1'b0;
                sel_opr_b = 1'b1;
                sel_pc    = 1'b0;
                sel_wb    = 2'b00;

                // immediate controls
                imm_type  = 3'b010;

                // operation controls
                aluop = 4'b1010; // add-U
            end
            // AUIPC-Type
            7'b0010111: // U-Type
            begin
                // memory controls
                rf_en = 1'b1;
                rd_en = 1'b0;
                wr_en = 1'b0;

                // mux controls
                sel_opr_a = 1'b1;
                sel_opr_b = 1'b1;
                sel_pc    = 1'b0;
                sel_wb    = 2'b00;

                // immediate controls
                imm_type  = 3'b010;

                // operation controls
                aluop = 4'b0000; // add-U
            end
            // B-Type
            7'b1100011:
            begin
                // memory controls
                rf_en = 1'b0;
                rd_en = 1'b0;
                wr_en = 1'b0;

                // mux controls
                sel_opr_a = 1'b1;
                sel_opr_b = 1'b1;
                sel_pc =  br_taken ? 1'b1 : 1'b0;
                sel_wb    = 2'b11;

                // immediate controls
                imm_type  = 3'b011;

                // operation controls
                aluop = 4'b0000;
                case (func3)
                3'b000: br_type = 3'b000;
                3'b001: br_type = 3'b001;
                3'b100: br_type = 3'b010;
                3'b101: br_type = 3'b011;
                3'b110: br_type = 3'b100;
                3'b111: br_type = 3'b101;
                endcase
            end
            7'b1110011: // CSR
            begin
                case (func3)
                3'b000: // CSRRW
                    begin
                        // csr memory controls
                        rf_en = 1'b1;
                        rd_en = 1'b0;
                        wr_en = 1'b0;

                        // csr mux controls
                        sel_opr_a = 1'b0;
                        sel_opr_b = 1'b1;
                        sel_pc    = 1'b0;
                        sel_wb    = 2'b11;

                        // csr immediate controls
                        imm_type  = 3'b000;

                        //csr reg
                        csr_rd       = 1'b1;
                        csr_wr       = 1'b1;
                        is_mret      = 1'b0;
                        aluop        = 4'b1010;
                    end

                default:
                    begin
                        // csr memory controls
                        rf_en = 1'b0;
                        rd_en = 1'b0;
                        wr_en = 1'b0;

                        // csr mux controls
                        sel_opr_a = 1'b0;
                        sel_opr_b = 1'b1;
                        sel_pc    = 1'b0;
                        sel_wb    = 2'b11;

                        // csr immediate controls
                        imm_type  = 3'b000;
                        
                        // csr reg
                        csr_rd       = 1'b0;
                        csr_wr       = 1'b0;
                        is_mret      = 1'b1;
                    end
                endcase
            end

            default:
            begin
                 // memory controls
                rf_en = 1'b0;
                rd_en = 1'b0;
                wr_en = 1'b0;

                // mux controls
                sel_opr_a = 1'b0;
                sel_opr_b = 1'b0;
                sel_pc    = 1'b0;
                sel_wb    = 2'b00;

                // immediate controls
                imm_type  = 3'b000;

                //csr reg
                csr_rd       = 1'b0;
                csr_wr       = 1'b0;
                // is_mret      = 1'b0;
                
            end
        endcase
    end

endmodule