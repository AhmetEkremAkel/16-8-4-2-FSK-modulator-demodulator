`timescale 1ns / 1ps

`timescale 1ns/1ps

module fsk_modulator_tb;

    // Giriþler
    reg clk;
    reg reset;
    reg data_in;

    // Çýkýþlar
    wire [31:0] sine_out;

    // Modülün örneði
    fsk_modulator uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .sine_out(sine_out)
    );

    // Saat sinyali oluþturma (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test vektörleri
    initial begin
        // Baþlangýç deðerleri
        reset = 1;
        data_in = 0;

        // Reset süresi
        #20;
        reset = 0;

        // Dijital veri giriþini saðlama
        #100 data_in = 1;  // Yüksek frekans
        #1000 data_in = 0; // Düþük frekans
        #1000 data_in = 1; // Yüksek frekans
        #1000 data_in = 0; // Düþük frekans
        #1000 data_in = 1; // Yüksek frekans
        #1000 data_in = 0; // Düþük frekans

        #2000 $finish;
    end

    // Çýkýþý dosyaya yazma (analog gösterim için)
    integer file;
    initial begin
        file = $fopen("sine_output.txt", "w");
    end

    always @(posedge clk) begin
        $fwrite(file, "%d\n", sine_out);
    end

    initial begin
        #5000 $fclose(file);
    end

endmodule

