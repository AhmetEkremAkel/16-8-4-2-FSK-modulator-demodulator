`timescale 1ns / 1ps

module fsk_demodulator(
    input wire clk,
    input wire reset,
    input wire signed [15:0] adc_in,
    output reg [3:0] data_out // 4-bit çıktı (0-15 arası)
);

    // Parametreler
    parameter N = 1000;               // Örnek sayısı
    parameter THRESHOLD = 32'd100000; // Enerji eşiği
    parameter real FS = 100000000.0;  // Örnekleme frekansı
    // Modülatörde 1 MHz-16 MHz arası frekanslar kullandığımızı varsayalım
    // frequency_increments'tan türetilen frekans değerleri:
    reg [31:0] freq_table [0:15];

    initial begin
        freq_table[0]  = 32'd1000000;
        freq_table[1]  = 32'd2000000;
        freq_table[2]  = 32'd3000000;
        freq_table[3]  = 32'd4000000;
        freq_table[4]  = 32'd5000000;
        freq_table[5]  = 32'd6000000;
        freq_table[6]  = 32'd7000000;
        freq_table[7]  = 32'd8000000;
        freq_table[8]  = 32'd9000000;
        freq_table[9]  = 32'd10000000;
        freq_table[10] = 32'd11000000;
        freq_table[11] = 32'd12000000;
        freq_table[12] = 32'd13000000;
        freq_table[13] = 32'd14000000;
        freq_table[14] = 32'd15000000;
        freq_table[15] = 32'd16000000;
    end


    // Örnekleri saklamak için buffer
    reg signed [15:0] sample_buffer[0:N-1];
    integer sample_index;

    // 16 frekans için akümülatörler
    real sin_acc[0:15];
    real cos_acc[0:15];
    real energy[0:15];

    integer i, f;
    real sample;
    real i_real;
    real angle;
    real max_energy;
    integer max_index;
    

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sample_index <= 0;
            data_out <= 0;
        end else begin
            // Örnekleri topla
            sample_buffer[sample_index] <= adc_in;
            sample_index <= sample_index + 1;

            if (sample_index == N) begin
                // Akümülatörleri sıfırla
                for (f = 0; f < 16; f = f + 1) begin
                    sin_acc[f] = 0.0;
                    cos_acc[f] = 0.0;
                end

                // Korelasyon hesaplaması
                for (i = 0; i < N; i = i + 1) begin
                    sample = sample_buffer[i];
                    i_real = i * 1.0;

                    // Her frekans için sin ve cos korelasyonu
                    for (f = 0; f < 16; f = f + 1) begin
                        angle = 2.0 * 3.1415926535 * (freq_table[f] / FS) * i_real;
                        sin_acc[f] = sin_acc[f] + (sample * $sin(angle));
                        cos_acc[f] = cos_acc[f] + (sample * $cos(angle));
                    end
                end

                // Enerji hesaplamaları
                for (f = 0; f < 16; f = f + 1) begin
                    energy[f] = (sin_acc[f]*sin_acc[f]) + (cos_acc[f]*cos_acc[f]);
                end

                // Maksimum enerjili frekansı bul
                max_energy = 0.0;
                max_index = data_out; // Eğer hiçbiri eşik geçemezse eski değer değişmez
                for (f = 0; f < 16; f = f + 1) begin
                    if (energy[f] > max_energy) begin
                        max_energy = energy[f];
                        max_index = f;
                    end
                end

                // Karar verme
                if (max_energy > THRESHOLD) begin
                    data_out <= max_index[3:0];
                end else begin
                    data_out <= data_out; // Enerji eşiği geçilmezse veri değişmez
                end

                // Örnek indeksi sıfırla
                sample_index <= 0;
            end
        end
    end

endmodule
