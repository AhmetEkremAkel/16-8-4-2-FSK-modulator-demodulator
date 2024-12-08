`timescale 1ns / 1ps

module fsk_demodulator_tb;

    // Girişler
    reg clk;
    reg reset;
    reg [3:0]data_in;

    // Çıkışlar
    wire [3:0]data_out;

    // Modülün örneği
    top_module uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Saat sinyali oluşturma (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    initial begin
        // Başlangıç değerleri
        reset = 1;

        // Reset süresi
        #20;
        reset = 0;
        data_in = 4'b0000;
        #10000 data_in = 4'b0001;
        #10000 data_in = 4'b0010;
        #10000 data_in = 4'b0011;
        #10000 data_in = 4'b0100;
        #10000 data_in = 4'b0101;
        #10000 data_in = 4'b0110;
        #10000 data_in = 4'b0111;
        #10000 data_in = 4'b1000;
        #10000 data_in = 4'b1001;
        #10000 data_in = 4'b1010;
        #10000 data_in = 4'b1011;
        #10000 data_in = 4'b1100;
        #10000 data_in = 4'b1101;
        #10000 data_in = 4'b1110;
        #10000 data_in = 4'b1111;
        #20000;

        #1000 $finish;
    end


endmodule
