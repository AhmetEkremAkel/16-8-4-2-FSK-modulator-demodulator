`timescale 1ns / 1ps

module fsk_demodulator_tb;

    // Parametreler
    parameter N = 1024;       // Örnek sayısı

    // Girişler
    reg clk;
    reg reset;
    reg signed [13:0] adc_in;

    // Çıkışlar
    wire data_out;

    // Modülün örneği
    fsk_demodulator uut (
        .clk(clk),
        .reset(reset),
        .adc_in(adc_in),
        .data_out(data_out)
    );

    // Saat sinyali oluşturma (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test vektörleri
    integer t;
    real amplitude;
    real freq;
    real t_real;

    initial begin
        // Başlangıç değerleri
        reset = 1;
        adc_in = 0;
        amplitude = 8000.0; // Sinyal genliği (real tipinde)

        // Reset süresi
        #20;
        reset = 0;

        // 1. Durum: Düşük frekanslı sinyal (data_out beklenen = 0)
        freq = 1.0;
        for (t = 0; t < N; t = t + 1) begin
            t_real = t * 1.0;
            adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
            #10;
        end

        // 2. Durum: Yüksek frekanslı sinyal (data_out beklenen = 1)
        freq = 2.0;
        for (t = 0; t < N; t = t + 1) begin
            t_real = t * 1.0;
            adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
            #10;
        end

        // 3. Durum: Düşük frekanslı sinyal (data_out beklenen = 0)
        freq = 1.0;
        for (t = 0; t < N; t = t + 1) begin
            t_real = t * 1.0;
            adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
            #10;
        end

        freq = 1.0;
        for (t = 0; t < N; t = t + 1) begin
            t_real = t * 1.0;
            adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
            #10;
        end

        // 2. Durum: Yüksek frekanslı sinyal (data_out beklenen = 1)
        freq = 2.0;
        for (t = 0; t < N; t = t + 1) begin
            t_real = t * 1.0;
            adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
            #10;
        end

        // 3. Durum: Düşük frekanslı sinyal (data_out beklenen = 0)
        freq = 1.0;
        for (t = 0; t < N; t = t + 1) begin
            t_real = t * 1.0;
            adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
            #10;
        end

        #1000 $finish;
    end

    // Çıkışı izleme
    initial begin
        $monitor("Time=%0t ns, adc_in=%0d, data_out=%b", $time, adc_in, data_out);
    end

endmodule
