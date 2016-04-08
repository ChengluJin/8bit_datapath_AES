module mux2_1(In1, In2, Out, sel);
    input [7:0] In1, In2;
    output [7:0] Out;
    input sel;

    assign Out = sel ? In1 : In2;
endmodule

module mux4_1(In1, In2, In3, In4, Out, sel);
    input [7:0] In1, In2, In3, In4;
    output [7:0] Out;
    input [1:0] sel;

    reg [7:0] Out_reg;
    assign Out = Out_reg;

    always@(*)
    begin
        case(sel)
            2'b00: Out_reg = In1;
            2'b01: Out_reg = In2;
            2'b10: Out_reg = In3;
            default: Out_reg = In4;
        endcase
    end
endmodule

