`timescale 1ns / 1ps

module fsk_modulator(
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [31:0] sine_out
);

    // Parametreler
    parameter PHASE_WIDTH = 32;
    parameter SINE_ROM_ADDR_WIDTH = 10;  // Sine ROM boyutu (2^10 = 1024)
    parameter SINE_ROM_SIZE = 1 << SINE_ROM_ADDR_WIDTH;

    // Faz biriktirici
    reg [PHASE_WIDTH-1:0] phase_accumulator;

    // Faz art�� de�erleri (y�ksek ve d���k frekanslar i�in)
    reg [PHASE_WIDTH-1:0] phase_increment;

    wire [PHASE_WIDTH-1:0] phase_increment_low = 32'd42949673;   // 1 MHz i�in
    wire [PHASE_WIDTH-1:0] phase_increment_high = 32'd214748365;  // 5 MHz i�in

    // Sine dalgas� ROM'u
    reg [31:0] sine_rom [0:SINE_ROM_SIZE-1];

    // Sine ROM'un ba�lang�� de�eri
    integer i;
    initial begin
        for (i = 0; i < SINE_ROM_SIZE; i = i + 1) begin
            sine_rom[i] = $rtoi(2147483647 * $sin(2.0 * 3.1415926535 * i / SINE_ROM_SIZE));
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            phase_accumulator <= 0;
            phase_increment <= 0;
            sine_out <= 0;
        end else begin
            // data_in de�erine g�re faz art���n� se�
            if (data_in)
                phase_increment <= phase_increment_high;
            else
                phase_increment <= phase_increment_low;

            // Faz biriktiriciyi g�ncelle
            phase_accumulator <= phase_accumulator + phase_increment;

            // Sine de�eri al
            sine_out <= sine_rom[phase_accumulator[PHASE_WIDTH-1:PHASE_WIDTH-SINE_ROM_ADDR_WIDTH]];
        end
    end

endmodule

