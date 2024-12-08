`timescale 1ns / 1ps

module fsk_modulator(
    input wire clk,
    input wire reset,
    input wire [3:0] data_in, // 4-bit veri girişi
    output reg [15:0] sine_out // 16-bit çıkış
);

    // Parametreler
    parameter PHASE_WIDTH = 16; 
    parameter SINE_ROM_ADDR_WIDTH = 15;  
    parameter SINE_ROM_SIZE = 1 << SINE_ROM_ADDR_WIDTH;

    // Faz biriktirici
    reg [PHASE_WIDTH-1:0] phase_accumulator =16'h0000;

    // 16 farklı frekans için faz artırım değerlerini saklayan dizi
    reg [PHASE_WIDTH-1:0]frequency_increments[0:15];
    reg [PHASE_WIDTH-1:0] phase_increment;

    // Örnek olarak 1 MHz den başlayarak 16 MHz e kadar lineer artışla varsayıyoruz.
    // (Değerleri kendi sisteminizin frekansına göre ayarlayın.)
    initial begin
        // Burada f_clk=100MHz varsayımı altında her MHz için hesaplanmış değerler kullanılıyor.
        frequency_increments[0]  = 16'd655;   // ~1 MHz
        frequency_increments[1]  = 16'd1311;  // ~2 MHz
        frequency_increments[2]  = 16'd1966;  // ~3 MHz
        frequency_increments[3]  = 16'd2621;  // ~4 MHz
        frequency_increments[4]  = 16'd3277;  // ~5 MHz
        frequency_increments[5]  = 16'd3932;  // ~6 MHz
        frequency_increments[6]  = 16'd4588;  // ~7 MHz
        frequency_increments[7]  = 16'd5243;  // ~8 MHz
        frequency_increments[8]  = 16'd5898;  // ~9 MHz
        frequency_increments[9]  = 16'd6554;  // ~10 MHz
        frequency_increments[10] = 16'd7209;  // ~11 MHz
        frequency_increments[11] = 16'd7865;  // ~12 MHz
        frequency_increments[12] = 16'd8520;  // ~13 MHz
        frequency_increments[13] = 16'd9176;  // ~14 MHz
        frequency_increments[14] = 16'd9831;  // ~15 MHz
        frequency_increments[15] = 16'd10486; // ~16 MHz
    end

    // Sine dalgası ROM'u
    reg [15:0]sine_rom[0:SINE_ROM_SIZE-1]; 

    integer i;
    initial begin
        for (i = 0; i < SINE_ROM_SIZE; i = i + 1) begin
            sine_rom[i] = $rtoi(16383 * $sin(2.0 * 3.1415926535 * i / SINE_ROM_SIZE)); 
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            phase_accumulator <= 0;
            phase_increment <= 0;
            sine_out <= 0;
        end else begin
            // data_in'e göre faz artırımını seç
            phase_increment <= frequency_increments[data_in[3:0]];

            // Faz biriktiriciyi güncelle
            phase_accumulator <= phase_accumulator + phase_increment;

            // Sine değeri al
            sine_out <= sine_rom[phase_accumulator[PHASE_WIDTH-1:PHASE_WIDTH-SINE_ROM_ADDR_WIDTH]];
        end
    end

endmodule
