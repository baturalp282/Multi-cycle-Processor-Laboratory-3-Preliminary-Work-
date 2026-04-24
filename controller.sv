module controller(input  logic clk,
                input  logic reset,
                input  logic [6:0] op,
                input  logic [2:0] funct3,
                input  logic funct7b5,
                input  logic zero,
                output logic [1:0] ImmSrc,
                output logic [1:0] ALUSrcA,
                output logic [1:0] ALUSrcB,
                output logic [1:0] ResultSrc,
                output logic AdrSrc,
                output logic [2:0] ALUControl,
                output logic IRWrite,
                output logic PCWrite,
                output logic RegWrite, 
                output logic MemWrite
);

    logic [1:0] ALUOp;
    logic Branch;
    logic PCUpdate;

    assign PCWrite = PCUpdate | (Branch & zero);

    // Main FSM

    main_fsm fsm (
        .clk(clk),
        .reset(reset),
        .op(op),
        .ALUOp(ALUOp),
        .AdrSrc(AdrSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .IRWrite(IRWrite),
        .MemWrite(MemWrite),
        .RegWrite(RegWrite),
        .PCUpdate(PCUpdate),
        .Branch(Branch)
    );

    // ALU Decoder 

    aludec ad (
        .opb5(op[5]),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUOp(ALUOp),           
        .ALUControl(ALUControl)  
    );

    // Instruction Decoder 

    instrdec id (
        .op(op),
        .ImmSrc(ImmSrc)       
    );

endmodule