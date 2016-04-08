module mixcolumn_8 (din, en, dout0, dout1, dout2, dout3, clk);
    input [7:0] din;
    input [7:0] en;
    output [7:0] dout0, dout1, dout2, dout3;
    input clk;
    
    reg [7:0] reg0, reg1, reg2, reg3;
    wire [7:0] din02, din03;
    
    assign din02 = {din[6:4], din[3] ^ din[7], din[2] ^ din[7] , din[1], din[0] ^ din[7], din[7]};
    assign din03 = {din[7] ^ din[6], din[6] ^ din[5], din[5] ^ din[4], din[4] ^ din[3] ^ din[7], din[3] ^ din[2] ^ din[7] , din[2] ^ din[1], din[1] ^ din[0] ^ din[7], din[0] ^ din[7]};

    always @ (posedge clk)
    begin
        reg0 <= din ^ (reg1 & en);
        reg1 <= din ^ (reg2 & en);
        reg2 <= din03 ^ (reg3 & en);
        reg3 <= din02 ^ (reg0 & en);
    end

    assign dout0 = reg0;
    assign dout1 = reg1;
    assign dout2 = reg2;
    assign dout3 = reg3;
endmodule

