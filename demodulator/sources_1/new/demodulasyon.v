`timescale 1ns / 1ps

module fsk_demodulator(
    input wire clk,
    input wire reset,
    input wire signed [13:0] adc_in,
    output reg data_out
);

    // Parametreler
    parameter N = 1024; // Örnek sayısı
    parameter THRESHOLD = 32'd1000000000; // Enerji eşiği (simülasyonda ayarlayın)

    // İç değişkenler
    reg signed [13:0] sample_buffer [0:N-1];
    integer sample_index;

    real energy_low;
    real energy_high;

    integer i;

    // Frekans katsayıları (test bench ile uyumlu olmalı)
    real freq_low = 1.0;
    real freq_high = 2.0;

    // Değişkenleri burada tanımlıyoruz
    real sample;
    real i_real;
    real angle_low;
    real angle_high;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sample_index <= 0;
            data_out <= 0;
        end else begin
            // Örnekleri topla
            sample_buffer[sample_index] <= adc_in;
            sample_index <= sample_index + 1;

            if (sample_index == N) begin
                // Enerji hesaplaması
                energy_low = 0.0;
                energy_high = 0.0;

                for (i = 0; i < N; i = i + 1) begin
                    sample = sample_buffer[i];
                    i_real = i * 1.0;

                    // Sinüs fonksiyonlarının argümanları
                    angle_low = 2.0 * 3.1415926535 * freq_low * i_real / (N - 1.0);
                    angle_high = 2.0 * 3.1415926535 * freq_high * i_real / (N - 1.0);

                    // Enerji hesaplamaları
                    energy_low = energy_low + sample * $sin(angle_low);
                    energy_high = energy_high + sample * $sin(angle_high);
                end

                // Enerjilerin karesini al
                energy_low = energy_low * energy_low;
                energy_high = energy_high * energy_high;

                // Karar verme
                if (energy_high > energy_low && energy_high > THRESHOLD)
                    data_out <= 1;
                else if (energy_low > energy_high && energy_low > THRESHOLD)
                    data_out <= 0;
                else
                    data_out <= data_out; // Veri değişmez

                // Örnek indeksi sıfırla
                sample_index <= 0;
            end
        end
    end

endmodule

