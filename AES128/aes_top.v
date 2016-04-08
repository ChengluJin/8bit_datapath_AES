module aes_8_bit (rst, clk, key_in, d_in, d_out, d_vld);
    input rst, clk;
    input [7:0] key_in;
    input [7:0] d_in;
    output [7:0] d_out;
    output reg d_vld;

    //key scheduler controller
    wire [3:0] round_cnt_w;
    reg input_sel, sbox_sel, last_out_sel, bit_out_sel;
    reg [7:0] rcon_en;
    reg [3:0] cnt;
    reg [7:0] round_cnt;
    reg [2:0] state;
    wire [7:0] rk_delayed_out, rk_last_out;
    reg [1:0] c3;
    wire pld;
    reg [7:0] mc_en_reg;
    reg pld_reg;
    wire [7:0] mc_en;
    reg [7:0] d_out;
    wire [7:0] d_out_w;

    always @ (posedge clk)
    begin
        d_out <= d_out_w;
    end

    assign pld = pld_reg;
    assign mc_en = mc_en_reg;
    assign round_cnt_w = round_cnt[7:4];

    key_expansion key (key_in, rk_delayed_out, round_cnt_w, rk_last_out, clk, input_sel, sbox_sel, last_out_sel, bit_out_sel, rcon_en);
    aes_data_path data_path (d_in, d_out_w, pld, c3, clk, mc_en, rk_delayed_out, rk_last_out);

    parameter load = 3'h0; //load 16 byte
    parameter b1st = 3'h1; //first byte need rcon
    parameter b2nd = 3'h2; //2byte go through sbox
    parameter b3rd = 3'h3; //last byte go through sbox from redundant register
    parameter norm = 3'h4; //normal round calculate two columns
    parameter shif = 3'h5; //shift 4 byte 

    //state machine for key schedule
    always @ (posedge clk)
    begin
        if (rst == 1'b1)
        begin
            state <= load;
            cnt <= 4'h0;
        end
        else
        begin
            case (state)
                load: 
                begin
                    cnt <= cnt + 4'h1;
                    if (cnt == 4'hf)
                    begin
                        state <= b1st;
                        cnt <= 4'h0;
                    end
                end

                b1st:
                begin
                    state <= b2nd;
                    cnt <= 4'h0;
                end

                b2nd:
                begin
                    cnt <= cnt + 4'h1;
                    if (cnt == 4'h1)
                    begin
                        state <= b3rd;
                        cnt <= 4'h0;
                    end
                end
                
                b3rd:
                begin
                    state <= norm;
                    cnt <= 4'h0;
                end

                norm: 
                begin
                    cnt <= cnt + 4'h1;
                    if(cnt == 4'h7)
                    begin
                        state <= shif;
                        cnt <= 4'h0;
                    end
                end

                shif:
                begin
                    cnt <= cnt + 4'h1;
                    if(cnt == 4'h3)
                    begin
                        state <= b1st;
                        cnt <= 4'h0;
                    end
                end
            endcase
        end
    end

    //mux select and rcon enable for key schedule
    always @ (*)
    begin
        case(state)
            load: 
            begin
                input_sel <= 1'b0;
                sbox_sel <= 1'b1;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b0;
                rcon_en <= 8'h00;
            end

            b1st:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b1;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b1;
                rcon_en <= 8'hFF;
            end
                 
            b2nd:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b1;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b1;
                rcon_en <= 8'h00;
            end

            b3rd:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b0;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b1;
                rcon_en <= 8'h00;
            end

            norm:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b0;
                last_out_sel <= 1'b1;
                bit_out_sel <= 1'b1;
                rcon_en <= 8'h00;
            end

            shif:
            begin
                input_sel <= 1'b1;
                sbox_sel <= 1'b0;
                last_out_sel <= 1'b1;
                bit_out_sel <= 1'b0;
                rcon_en <= 8'h00;
            end

            default: 
            begin
                input_sel <= 1'b0;
                sbox_sel <= 1'b1;
                last_out_sel <= 1'b0;
                bit_out_sel <= 1'b0;
                rcon_en <= 8'h00;
            end
        endcase
    end

    //round counter
    always @ (posedge clk)
    begin
        if (rst == 1'b1 || cnt == 4'hf || round_cnt_w == 4'ha)
        begin
            round_cnt <= 6'h00;
        end
        else
        begin
            round_cnt <= round_cnt + 6'h01;
        end
    end


   
    //state machine shift row
    always @ (posedge clk)
    begin
        if (state == load) 
        begin
            c3 <= 2'h3;
        end
        else
        begin
            case (round_cnt[3:0])
                4'h0: c3 <= 2'h2;
                4'h1: c3 <= 2'h1;
                4'h2: c3 <= 2'h0;
                4'h3: c3 <= 2'h3;
                4'h4: c3 <= 2'h2;
                4'h5: c3 <= 2'h1;
                4'h6: c3 <= 2'h1;
                4'h7: c3 <= 2'h3;
                4'h8: c3 <= 2'h2;
                4'h9: c3 <= 2'h3;
                4'hA: c3 <= 2'h2;
                4'hB: c3 <= 2'h3;
                4'hC: c3 <= 2'h3;
                4'hD: c3 <= 2'h3;
                4'hE: c3 <= 2'h3;
                4'hF: c3 <= 2'h3;
            endcase
        end
    end

    //mixcoloumn enable
    always @ (posedge clk)
    begin
        if (round_cnt[1:0] == 2'b11)
        begin
            mc_en_reg <= 8'h00;
        end
        else
        begin
            mc_en_reg <= 8'hFF;
        end
    end

    //parelle load
    always @ (posedge clk)
    begin
        if (state == load)
        begin
            pld_reg <= 1'b0;
        end
        else
        begin
            if (round_cnt[1:0] == 2'b11)
            begin
                pld_reg <= 1'b1;
            end
            else
            begin
                pld_reg <= 1'b0;
            end
        end
    end

    always @(posedge clk)
    begin
        if (rst == 1'b1)
        begin
            d_vld <= 1'b0;
        end
        else
        begin
            if (round_cnt == 8'h90)
            begin
                d_vld <= 1'b1;
            end
        end
    end
endmodule

