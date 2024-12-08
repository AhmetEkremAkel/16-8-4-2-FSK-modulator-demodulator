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

    reg [15:0]noise;
    integer noise_constant;
    integer j;
    integer seed;
    initial begin
    seed = $time; // Simülasyon zamanı kullanılarak farklı bir seed elde edilebilir
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
        /*
        for (j = 0;j<5 ;j=j+1 ) begin
            //noise_constant = noise_constant + 50;
            freq = 1000000.0;
            for (t = 0; t < N; t = t + 1) begin
                t_real = t * 1.0;
                adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
                noise = ($random(seed) % noise_constant) - (noise_constant/2);
                adc_in = adc_in + noise;
                #10;
            end
            // 1. Durum: Düşük frekanslı sinyal (data_out beklenen = 0)
            freq = 1000000.0;
            for (t = 0; t < N; t = t + 1) begin
                t_real = t * 1.0;
                adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
                noise = ($random(seed) % noise_constant) - (noise_constant/2);
                adc_in = adc_in + noise;
                #10;
            end

            // 2. Durum: Yüksek frekanslı sinyal (data_out beklenen = 1)
            freq = 2000000.0;
            for (t = 0; t < N; t = t + 1) begin
                t_real = t * 1.0;
                adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
                noise = ($random(seed) % noise_constant) - (noise_constant/2);
                adc_in = adc_in + noise;
                #10;
            end
            // 2. Durum: Yüksek frekanslı sinyal (data_out beklenen = 1)
            freq = 2000000.0;
            for (t = 0; t < N; t = t + 1) begin
                t_real = t * 1.0;
                adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
                noise = ($random(seed) % noise_constant) - (noise_constant/2);
                adc_in = adc_in + noise;
                #10;
            end
            // 3. Durum: Düşük frekanslı sinyal (data_out beklenen = 0)
            freq = 1000000.0;
            for (t = 0; t < N; t = t + 1) begin
                t_real = t * 1.0;
                adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
                noise = ($random(seed) % noise_constant) - (noise_constant/2);
                adc_in = adc_in + noise;
                #10;
            end

            freq = 2000000.0;
            for (t = 0; t < N; t = t + 1) begin
                t_real = t * 1.0;
                adc_in = $rtoi(amplitude * $sin(2.0 * 3.1415926535 * freq * t_real / (N - 1.0)));
                noise = ($random(seed) % noise_constant) - (noise_constant/2);
                adc_in = adc_in + noise;
                #10;
            end
        end*/
        #1000 $finish;
    end


endmodule
