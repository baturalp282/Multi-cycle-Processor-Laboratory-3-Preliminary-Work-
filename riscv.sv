module riscv(
    input  logic        clk, reset,
    output logic [31:0] Adr, WriteData,
    output logic        MemWrite,
    input  logic [31:0] ReadData
);

    logic [31:0] Instr;
    logic [1:0]  ALUSrcA, ALUSrcB, ResultSrc, ImmSrc;
    logic [2:0]  ALUControl;
    logic        IRWrite, PCWrite, AdrSrc, RegWrite;
    logic        Zero;

    // Controller
    
    controller c(
            .clk(clk), 
            .reset(reset),
            .op(Instr[6:0]),            
            .funct3(Instr[14:12]),      
            .funct7b5(Instr[30]),       
            .zero(Zero),
            .ImmSrc(ImmSrc), 
            .ALUSrcA(ALUSrcA), 
            .ALUSrcB(ALUSrcB),
            .ResultSrc(ResultSrc), 
            .AdrSrc(AdrSrc),
            .ALUControl(ALUControl), 
            .IRWrite(IRWrite), 
            .PCWrite(PCWrite),
            .RegWrite(RegWrite), 
            .MemWrite(MemWrite)
        );

    // Datapath
    
    datapath dp(
        .clk(clk), .reset(reset),
        .PCWrite(PCWrite), .AdrSrc(AdrSrc), .IRWrite(IRWrite),
        .ResultSrc(ResultSrc), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc), .ALUControl(ALUControl), .RegWrite(RegWrite),
        .Zero(Zero), .Instr(Instr),
        .Adr(Adr), .WriteData(WriteData), .ReadData(ReadData)
    );

endmodule