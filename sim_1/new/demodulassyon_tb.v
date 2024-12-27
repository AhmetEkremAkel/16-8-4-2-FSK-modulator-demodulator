`timescale 1ns / 1ps

module channel_effects_tb;

    // Testbench sinyalleri
    reg clk;
    reg signed [17:0] in1, in2;
    wire signed [17:0] out1, out2;

    integer f;  // Dosya değişkeni

    // DUT (Device Under Test)
    channel_effects dut (
        .clk(clk),
        .input_1(in1),
        .input_2(in2),
        .output_1(out1),
        .output_2(out2)
    );

    // 1) Saat üretme (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 2) Test senaryosu
    initial begin
        // Dosyayı aç
        f = $fopen("noise_output_2.txt", "w");

        in1 = 0;  
        in2 = 0;
        #20000;




        // Bir süre sonra simülasyon kapansın

        $fclose(f);
        $stop;
    end

    // 3) Her clock kenarında konsola ve dosyaya yazdır
    always @(posedge clk) begin
        // Konsola
        $display($time, " ns :: in1=%d in2=%d => out1=%d out2=%d",
                          in1,   in2,        out1,    out2);
        // Dosyaya
        $fwrite(f, "%d %d\n", out1, out2);
    end

endmodule
