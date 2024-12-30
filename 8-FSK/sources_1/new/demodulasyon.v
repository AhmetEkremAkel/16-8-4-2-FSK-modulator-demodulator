`timescale 1ns / 1ps

module fsk_demodulator(
    input  wire                 clk,
    input  wire                 reset,
    input  wire signed [17:0]   adc_in_sin, // I bileşeni
    input  wire signed [17:0]   adc_in_cos, // Q bileşeni
    output reg  [2:0]           data_out    // 3-bit çıktı (0-7 arası)
);

    // Parametreler
    parameter N          = 99;             // Örnek sayısı
    parameter THRESHOLD  = 32'd10000;      // Enerji eşiği
    parameter real FS    = 90_000_000.0;   // Örnekleme frekansı

    // Senkronizasyon için parametreler
    parameter SYNC_THRESHOLD     = 1;      // Kare dalgayı algılama eşiği
    parameter SYNC_COUNT_REQUIRED= 8;      // Bu kadar ardışık örnek boyunca sinyal eşiğin üzerinde kalırsa sync kabul et

    reg sync_detected;
    reg [7:0] sync_pattern_counter;

    // Frekans tablosu (1MHz-8MHz arası)
    // 16 yerine sadece 8 adet frekans saklıyoruz
    reg [31:0] freq_table [0:7];
    initial begin
        freq_table[0] = 32'd1000000;  // ~1 MHz
        freq_table[1] = 32'd2000000;  // ~2 MHz
        freq_table[2] = 32'd3000000;  // ~3 MHz
        freq_table[3] = 32'd4000000;  // ~4 MHz
        freq_table[4] = 32'd5000000;  // ~5 MHz
        freq_table[5] = 32'd6000000;  // ~6 MHz
        freq_table[6] = 32'd7000000;  // ~7 MHz
        freq_table[7] = 32'd8000000;  // ~8 MHz
    end

    // Örnekleri saklamak için buffer
    reg signed [15:0] sample_buffer_I[0:N-1];
    reg signed [15:0] sample_buffer_Q[0:N-1];
    integer sample_index;

    // 8 frekans için korelasyon akümülatörleri (16 yerine 8 adet)
    real C_i[0:7];
    real C_q[0:7];
    real energy[0:7];

    integer i, f;
    real I_s, Q_s;
    real angle;
    real max_energy;
    integer max_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sample_index         <= 0;
            data_out            <= 0;
            sync_detected       <= 0;
            sync_pattern_counter<= 0;
        end 
        else begin
            if (!sync_detected) begin
                // Senkronizasyon işareti arıyoruz
                if (adc_in_sin > SYNC_THRESHOLD) begin
                    sync_pattern_counter <= sync_pattern_counter + 1;
                    if (sync_pattern_counter >= SYNC_COUNT_REQUIRED) begin
                        sync_detected <= 1;
                        sample_index  <= 0; // Sync bulduktan sonra örneklemeye başla
                    end
                end 
                else begin
                    sync_pattern_counter <= 0;
                end
            end 
            else begin
                // Sync bulundu, normal demodülasyon süreci
                sample_buffer_I[sample_index] <= adc_in_sin;
                sample_buffer_Q[sample_index] <= adc_in_cos;
                sample_index <= sample_index + 1;

                if (sample_index == N) begin
                    // Akümülatörleri sıfırla
                    for (f = 0; f < 8; f = f + 1) begin
                        C_i[f] = 0.0;
                        C_q[f] = 0.0;
                    end

                    // Korelasyon hesaplaması (N adet örnek üzerinde)
                    for (i = 0; i < N; i = i + 1) begin
                        I_s = sample_buffer_I[i];
                        Q_s = sample_buffer_Q[i];

                        // Her frekans için
                        for (f = 0; f < 8; f = f + 1) begin
                            angle = 2.0 * 3.1415926535 *
                                    (freq_table[f] / FS) * i;

                            // Kompleks korelasyon
                            C_i[f] = C_i[f] + (I_s * $cos(angle) - Q_s * $sin(angle));
                            C_q[f] = C_q[f] + (I_s * $sin(angle) + Q_s * $cos(angle));
                        end
                    end

                    // Enerji hesaplaması
                    max_energy = 0.0;
                    max_index  = 0; 
                    for (f = 0; f < 8; f = f + 1) begin
                        energy[f] = (C_i[f]*C_i[f]) + (C_q[f]*C_q[f]);
                        if (energy[f] > max_energy) begin
                            max_energy = energy[f];
                            max_index  = f;
                        end
                    end

                    // Karar verme
                    if (max_energy > THRESHOLD) begin
                        data_out <= max_index[2:0]; 
                    end 
                    else begin
                        data_out <= data_out; // eşiği geçmiyorsa eski değerde kal
                    end

                    // Örnek indeksi sıfırla
                    sample_index <= 0;
                end
            end
        end
    end
endmodule