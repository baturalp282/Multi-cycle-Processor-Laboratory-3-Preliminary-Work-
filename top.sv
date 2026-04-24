module top (input  logic        clk, reset, 
            output logic [31:0] WriteData, DataAdr, 
            output logic        MemWrite
);

    logic [31:0] ReadData;

    // RISC-V 
 
    riscv rv (
        .clk(clk), 
        .reset(reset), 
        .Adr(DataAdr),          
        .WriteData(WriteData),   
        .MemWrite(MemWrite),     
        .ReadData(ReadData)      
    );

    // Unified Memory
  
    mem m (
        .clk(clk), 
        .we(MemWrite), 
        .a(DataAdr), 
        .wd(WriteData), 
        .rd(ReadData)
    );

endmodule