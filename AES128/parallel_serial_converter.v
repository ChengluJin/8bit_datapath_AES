module ps_conv(din, dout, pdin, pld, clk);
    input [7:0] din;
    output [7:0] dout; 
    input [31:0] pdin; // highest byte go out first
    input pld; // 1 means parallel load, 0 means serial unload
    input clk;

    reg [7:0] reg3, reg2, reg1, reg0;

    wire [7:0] mux1_o, mux2_o, mux3_o;

    mux2_1 mux0 (pdin[31:24], reg0, dout, pld);
    mux2_1 mux1 (pdin[23:16], reg1, mux1_o, pld);
    mux2_1 mux2 (pdin[15: 8], reg2, mux2_o, pld);
    mux2_1 mux3 (pdin[ 7: 0], reg3, mux3_o, pld);

    always @ (posedge clk)
    begin
        reg3 <= din;
        reg2 <= mux3_o;
        reg1 <= mux2_o;
        reg0 <= mux1_o;
    end
endmodule
        
