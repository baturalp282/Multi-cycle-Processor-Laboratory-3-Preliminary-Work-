module alu(input  logic [31:0] SrcA, SrcB,
           input  logic [2:0]  ALUControl,
           output logic [31:0] ALUResult,
           output logic        Zero);

  logic [31:0] condinvb, sum;

  assign condinvb = ALUControl[0] ? ~SrcB : SrcB;
  assign sum = SrcA + condinvb + ALUControl[0];

  always_comb
    case (ALUControl)
      3'b000: ALUResult = sum;         // add
      3'b001: ALUResult = sum;         // subtract
      3'b010: ALUResult = SrcA & SrcB; // and
      3'b011: ALUResult = SrcA | SrcB; // or
      3'b101: ALUResult = sum[31];     // slt
      default: ALUResult = 32'bx;
    endcase

  assign Zero = (ALUResult == 32'b0);
endmodule
