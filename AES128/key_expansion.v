module key_expansion(key_in, rk_delayed_out, round_cnt, rk_last_out, clk, input_sel, sbox_sel, last_out_sel, bit_out_sel, rcon_en);
    input [7:0] key_in;
    output [7:0] rk_delayed_out;
    output [7:0] rk_last_out;
    input [3:0] round_cnt;
    input clk;
    input input_sel, sbox_sel, last_out_sel, bit_out_sel; 
    input [7:0] rcon_en;

    reg [7:0] r15, r14, r13, r12, r11, r10, r9, r8, r7, r6, r5, r4, r3, r2, r1, r0, r_redun;
    wire [7:0] rcon_sbox_o, sbox_o, rcon_o, sbox_in, mux_in_o, mux_bit_o, rcon_num;
    
    function [7:0] rcon;
      input [3:0] x;
        casex (x)
          4'b0000: rcon = 8'h01;
          4'b0001: rcon = 8'h02;
          4'b0010: rcon = 8'h04;
          4'b0011: rcon = 8'h08;
          4'b0100: rcon = 8'h10;
          4'b0101: rcon = 8'h20;
          4'b0110: rcon = 8'h40;
          4'b0111: rcon = 8'h80;
          4'b1000: rcon = 8'h1b;
          4'b1001: rcon = 8'h36;
          default: rcon = 8'h01;
        endcase
    endfunction

    assign rcon_num = rcon(round_cnt);


    assign rcon_sbox_o = sbox_o ^ rcon_o;
    assign rcon_o = rcon_en & rcon_num;
    assign rk_delayed_out = r12;
    

    mux2_1 mux_in (rk_last_out, key_in, mux_in_o, input_sel);
    mux2_1 mux_sbox (r13, r_redun, sbox_in, sbox_sel); 
    mux2_1 mux_bit ((r4 ^ rk_last_out), r4, mux_bit_o, bit_out_sel); 
    mux2_1 mux_last_out (r0, ( r0 ^ rcon_sbox_o),  rk_last_out, last_out_sel);
    bSbox sbox (sbox_in, sbox_o);

    always @ (posedge clk)
    begin
        r15 <= mux_in_o;
        r14 <= r15;
        r13 <= r14;
        r12 <= r13;
        r11 <= r12;
        r10 <= r11;
        r9 <= r10;
        r8 <= r9;
        r7 <= r8;
        r6 <= r7;
        r5 <= r6;
        r4 <= r5;
        r3 <= mux_bit_o;
        r2 <= r3;
        r1 <= r2;
        r0 <= r1;
    end
    
    always @ (posedge clk)
    begin
        if (rcon_en == 8'hff)
        begin
            r_redun <= r12;
        end
    end 
endmodule
