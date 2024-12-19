`timescale 1ns / 1ps

module fsk_demodulator_tb;

    // Girişler
    reg clk;
    reg reset;
    reg [3:0]data_in;
    reg start;

    // Çıkışlar
    wire [3:0]data_out;


    // Modülün örneği
    top_module uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .start(start),
        .data_out(data_out)
    );

    // Saat sinyali oluşturma (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer j;
    integer seed;
    initial begin
    seed = $time; // Simülasyon zamanı kullanılarak farklı bir seed elde edilebilir
    end

    initial begin
        // Başlangıç değerleri
        reset = 1;
        start = 0;
        // Reset süresi
        #200;
        start = 1;
        reset = 0;
        #20;
        start = 0;
        #80;
        data_in = 4'b0000;
        for ( j= 0;j<3;j=j+1)begin
            #1000 data_in = 4'b0000;
            #1000 data_in = 4'b0001;
            #1000 data_in = 4'b0010;
            #1000 data_in = 4'b0011;
            #1000 data_in = 4'b0100;
            #1000 data_in = 4'b0101;
            #1000 data_in = 4'b0110;
            #1000 data_in = 4'b0111;
            #1000 data_in = 4'b1000;
            #1000 data_in = 4'b1001;
            #1000 data_in = 4'b1010;
            #1000 data_in = 4'b1011;
            #1000 data_in = 4'b1100;
            #1000 data_in = 4'b1101;
            #1000 data_in = 4'b1110;
            #1000 data_in = 4'b1111;
        end
        #1000 $finish;

    end


endmodule
