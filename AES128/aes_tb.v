`timescale 1ns/1ns

module aes_tb;
    reg rst;
    reg clk;
    reg [7:0] key_in;
    reg [7:0] d_in;
    wire [7:0] d_out;
    wire d_vld;
    parameter CP = 20;

    //Two test vectors
    //Simple example
    //CT = 0x69c4e0d86a7b0430d8cdb78070b4c55a
    parameter kin = 128'h000102030405060708090a0b0c0d0e0f;
    parameter din = 128'h00112233445566778899aabbccddeeff;

    //Example in FIPS-197
    //CT = 0x3925841d02dc09fbdc118597196a0b32
    //parameter kin = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    //parameter din = 128'h3243f6a8885a308d313198a2e0370734;

    aes_8_bit test (rst, clk, key_in, d_in, d_out, d_vld);

    always # (CP/2)
    begin
        clk = ~ clk;
    end
    
    initial begin
        
        rst = 1'b1;
        clk = 1'b1;
        
        #CP
        rst = 1'b0;
        key_in = kin[127:120];
        d_in = din[127:120];

        #CP
        key_in = kin[119:112];
        d_in = din[119:112];

        #CP
        key_in = kin[111:104];
        d_in = din[111:104];

        #CP
        key_in = kin[103:96];
        d_in = din[103:96];

        #CP
        key_in = kin[95:88];
        d_in = din[95:88];

        #CP
        key_in = kin[87:80];
        d_in = din[87:80];

        #CP
        key_in = kin[79:72];
        d_in = din[79:72];

        #CP
        key_in = kin[71:64];
        d_in = din[71:64];

        #CP
        key_in = kin[63:56];
        d_in = din[63:56];

        #CP
        key_in = kin[55:48];
        d_in = din[55:48];

        #CP
        key_in = kin[47:40];
        d_in = din[47:40];

        #CP
        key_in = kin[39:32];
        d_in = din[39:32];

        #CP
        key_in = kin[31:24];
        d_in = din[31:24];

        #CP
        key_in = kin[23:16];
        d_in = din[23:16];

        #CP
        key_in = kin[15:8];
        d_in = din[15:8];

        #CP
        key_in = kin[7:0];
        d_in = din[7:0];
    end
endmodule

