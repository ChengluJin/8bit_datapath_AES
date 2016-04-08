module aes_data_path(d_in, d_out, pld, c3, clk, mc_en, rk_delayed_out, rk_last_out);
    input [7:0] d_in;
    output [7:0] d_out;
    input pld;
    input [1:0] c3;
    input clk;
    input [7:0] mc_en;
    input [7:0] rk_delayed_out, rk_last_out;
    
    wire [7:0] sr_in, sr_out, s_out, mc_out0, mc_out1, mc_out2, mc_out3, sbox_o;
    wire [31:0] pdin;

    assign pdin = {mc_out0, mc_out1, mc_out2, mc_out3};
    assign sr_in = rk_delayed_out ^ s_out;
    assign d_out = sbox_o ^ rk_last_out;

    byte_permutation SR (sr_in, sr_out, c3, clk);
    ps_conv PS (d_in, s_out, pdin, pld, clk);
    mixcolumn_8 MC (sbox_o, mc_en, mc_out0, mc_out1, mc_out2, mc_out3, clk);
    bSbox SB (sr_out, sbox_o);
endmodule

