module byte_permutation (din, dout, c3, clk);
    input [7:0] din;
    output [7:0] dout;
    input [1:0] c3;
    input clk;

    wire c0, c1, c2;
    wire [7:0] mux0_o, mux1_o, mux2_o;
    reg [7:0] reg12, reg11, reg10, reg9, reg8, reg7, reg6, reg5, reg4, reg3, reg2, reg1;

    assign c0 = ~ (c3[1] | c3[0]);
    assign c1 = ~ (c3[1] | (~ c3[0])); 
    assign c2 = ~ ((~ c3[1]) | c3[0]);

    mux2_1 mux0 (reg1, din, mux0_o, c0);
    mux2_1 mux1 (reg1, reg9, mux1_o, c1);
    mux2_1 mux2 (reg1, reg5, mux2_o, c2);
    mux4_1 mux3 (din, reg9, reg5, reg1, dout, c3);

    always @ (posedge clk)
    begin
        reg12 <= mux0_o;
        reg11 <= reg12;
        reg10 <= reg11;
        reg9  <= reg10;
        reg8  <= mux1_o;
        reg7  <= reg8;
        reg6  <= reg7;
        reg5  <= reg6;
        reg4  <= mux2_o;
        reg3  <= reg4;
        reg2  <= reg3;
        reg1  <= reg2;
    end
endmodule
        
