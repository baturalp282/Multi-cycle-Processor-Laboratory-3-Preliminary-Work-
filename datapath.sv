module datapath(input  logic clk, reset,
    // The signals which is coming from Controller
    input  logic        PCWrite, AdrSrc, IRWrite,
    input  logic [1:0]  ResultSrc, ALUSrcA, ALUSrcB, ImmSrc,
    input  logic [2:0]  ALUControl,
    input  logic        RegWrite,
    // The signals which is going to Controller
    output logic        Zero,
    output logic [31:0] Instr,
    // The signals which is coming/going from/to Controller
    output logic [31:0] Adr, WriteData,
    input  logic [31:0] ReadData
);

    logic [31:0] PC, OldPC;
    logic [31:0] Data;
    logic [31:0] RD1, RD2, A, B; 
    logic [31:0] ImmExt;
    logic [31:0] SrcA, SrcB;
    logic [31:0] ALUResult, ALUOut;
    logic [31:0] Result;

    // PC & Address Logic

    flopenr #(32) pcreg (clk, reset, PCWrite, Result, PC); 
    mux2 #(32) adrmux (PC, Result, AdrSrc, Adr);

    // Instruction & Data Registers

    flopenr #(32) ir (clk, reset, IRWrite, ReadData, Instr);
    flopenr #(32) oldpcreg (clk, reset, IRWrite, PC, OldPC); // !!!!!!!! BURAYA BAK NİYE DEĞİŞTİ ETKİSİ NE
    flopr #(32) datareg (clk, reset, ReadData, Data);

    // Register File & Sign Extension

    regfile rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, RD1, WriteData);
    extend ext (Instr[31:7], ImmSrc, ImmExt);

    // ALU Registers & Muxes

    flopr #(32) areg (clk, reset, RD1, A);
    flopr #(32) breg (clk, reset, WriteData, B); 

    mux3 #(32) srcamux (PC, OldPC, A, ALUSrcA, SrcA);
    mux3 #(32) srcbmux (B, ImmExt, 32'd4, ALUSrcB, SrcB);

    // ALU & Result Logic
    alu alu (SrcA, SrcB, ALUControl, ALUResult, Zero);
    
    flopr #(32) aluoutreg (clk, reset, ALUResult, ALUOut);

    mux3 #(32) resmux (ALUOut, Data, ALUResult, ResultSrc, Result);

endmodule