`timescale 1ns / 1ps

module fsk_demodulator(
    input wire clk,
    input wire reset,
    input wire signed [15:0] adc_in_sin, // I bileşeni
    input wire signed [15:0] adc_in_cos, // Q bileşeni
    output reg [3:0] data_out // 4-bit çıktı (0-15 arası)
);

    // Parametreler
    parameter N = 99;              // Örnek sayısı
    parameter THRESHOLD = 32'd10000; // Enerji eşiği
    parameter real FS = 100000000.0;  // Örnekleme frekansı

    // Frekans tablosu (1MHz-16MHz arası)
    reg [31:0] freq_table [0:15];
    initial begin
        freq_table[0]  = 32'd1_000_000;
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
    reg signed [15:0] sample_buffer_I[0:N-1];
    reg signed [15:0] sample_buffer_Q[0:N-1];
    integer sample_index;

    // 16 frekans için korelasyon akümülatörleri
    real C_i[0:15];
    real C_q[0:15];
    real energy[0:15];

    integer i, f;
    real I_s, Q_s;
    real angle;
    real max_energy;
    integer max_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sample_index <= 0;
            data_out <= 0;
        end else begin
            // Örnekleri topla
            sample_buffer_I[sample_index] <= adc_in_sin;
            sample_buffer_Q[sample_index] <= adc_in_cos;
            sample_index <= sample_index + 1;

            if (sample_index == N) begin
                // Akümülatörleri sıfırla
                for (f = 0; f < 16; f = f + 1) begin
                    C_i[f] = 0.0;
                    C_q[f] = 0.0;
                end

                // Korelasyon hesaplaması (N adet örnek üzerinde)
                for (i = 0; i < N; i = i + 1) begin
                    I_s = sample_buffer_I[i];
                    Q_s = sample_buffer_Q[i];

                    // Her frekans için
                    for (f = 0; f < 16; f = f + 1) begin
                        angle = 2.0 * 3.1415926535 * (freq_table[f] / FS) * i;

                        // Kompleks korelasyon
                        // C_i[f] = Σ [I_s*cos(angle) + Q_s*sin(angle)]
                        // C_q[f] = Σ [-I_s*sin(angle) + Q_s*cos(angle)]

                        C_i[f] = C_i[f] + (I_s * $cos(angle) - Q_s * $sin(angle));
                        C_q[f] = C_q[f] + (I_s * $sin(angle) + Q_s * $cos(angle));
                    end
                end

                // Enerji hesaplamaları
                max_energy = 0.0;
                max_index = 0; // Eğer hiçbiri eşiği geçmezse mevcut değerde kal

                for (f = 0; f < 16; f = f + 1) begin
                    energy[f] = (C_i[f]*C_i[f]) + (C_q[f]*C_q[f]);
                    if (energy[f] > max_energy) begin
                        max_energy = energy[f];
                        max_index = f;
                    end
                end

                // Karar verme
                if (max_energy > THRESHOLD) begin
                    data_out <= max_index[3:0];
                end else begin
                    data_out <= data_out; // eşiği geçmiyorsa eski değerde kal
                end

                // Örnek indeksi sıfırla
                sample_index <= 0;
            end
        end
    end

endmodule
