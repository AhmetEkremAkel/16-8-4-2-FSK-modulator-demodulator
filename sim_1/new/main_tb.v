`timescale 1ns / 1ps

`timescale 1ns/1ps

module fsk_modulator_tb;

    // Giri�ler
    reg clk;
    reg reset;
    reg data_in;

    // ��k��lar
    wire [31:0] sine_out;

    // Mod�l�n �rne�i
    fsk_modulator uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .sine_out(sine_out)
    );

    // Saat sinyali olu�turma (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test vekt�rleri
    initial begin
        // Ba�lang�� de�erleri
        reset = 1;
        data_in = 0;

        // Reset s�resi
        #20;
        reset = 0;

        // Dijital veri giri�ini sa�lama
        #100 data_in = 1;  // Y�ksek frekans
        #1000 data_in = 0; // D���k frekans
        #1000 data_in = 1; // Y�ksek frekans
        #1000 data_in = 0; // D���k frekans
        #1000 data_in = 1; // Y�ksek frekans
        #1000 data_in = 0; // D���k frekans

        #2000 $finish;
    end

    // ��k��� dosyaya yazma (analog g�sterim i�in)
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

