`timescale 1ns / 1ps

module fsk_demodulator_tb;

    // Girişler
    reg clk;
    reg reset;
    reg [2:0] data_in;
    reg start;

    // Çıkışlar
    wire [2:0] data_out;

    // DUT
    top_module uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .start(start),
        .data_out(data_out)
    );

    // Saat sinyali (100 MHz -> 10 ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Hata sayacı ve toplam kontrol sayacı
    integer error_count = 0;   // <--- Eklendi
    integer total_count = 0;   // <--- Eklendi

    // Bir önceki data_in değerini tutacak register
    reg [2:0] last_data_in;    // <--- Eklendi

    integer j;

    initial begin
        // Her simulasyonda farklı bir seed için $time kullanabiliriz
        $srandom($time);
        
        // Ya da simulasyon parametresi olarak dışarıdan alabiliriz
        // $srandom(SEED_VALUE);
    end

    initial begin
        // Her simulasyonda farklı bir seed için $time kullanabiliriz
        $srandom(32'hDEAD_BEEF);
        
        // Ya da simulasyon parametresi olarak dışarıdan alabiliriz
        // $srandom(SEED_VALUE);
    end

    initial begin
        // Başlangıç değerleri
        reset = 1;
        start = 0;
        // Reset süresi
        #200;
        start = 1;
        reset = 0;
        #20;
        start = 0;
        #80;

        // Başlarken last_data_in'i sıfırla (veya data_in ile aynı yap)
        last_data_in = 4'b000; // <--- Eklendi
        data_in = 4'b000;      // Bu da ilk değerimiz
        #20;
        for (j = 0; j < 50; j = j + 1) begin


            // 0)
            #1000 data_in = 4'b000;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 1) 
            #1000;
            data_in = 4'b001;
            total_count = total_count + 1; 
            
            if (data_out != last_data_in) error_count = error_count + 1; 
            last_data_in = data_in;

            // 2) 
            #1000;
            data_in = 4'b010;
            total_count = total_count + 1;

            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 3)
            #1000 data_in = 4'b011;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 4) 
            #1000 data_in = 4'b100;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 5) 
            #1000 data_in = 4'b101;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 6) 
            #1000 data_in = 4'b110;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 7) 
            #1000 data_in = 4'b111;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;


        end
        
        // Bir tur daha bekleyip toplam hatayı ekrana basıyoruz
        #1000;
        $display("Error Count = %d, Total Count = %d, BER = %f",
                 error_count, total_count,
                 error_count*1.0 / total_count);
        
        $finish;
    end

endmodule