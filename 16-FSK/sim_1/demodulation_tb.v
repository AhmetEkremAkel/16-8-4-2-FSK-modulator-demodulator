`timescale 1ns / 1ps

module fsk_demodulator_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [3:0] data_in;
    reg start;

    // Outputs
    wire [3:0] data_out;

    // DUT
    top_module uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .start(start),
        .data_out(data_out)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Hata sayacı ve toplam kontrol sayacı
    integer error_count = 0;  
    integer total_count = 0;  

    // Bir önceki data_in değerini tutacak register
    reg [3:0] last_data_in;    

    integer j;

    initial begin
        
        $srandom($time);
        
        
    end

    initial begin
        
        $srandom(32'hDEAD_BEEF);
        
        
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

        last_data_in = 4'b0001; 
        data_in = 4'b0001;     
        #20;
        for (j = 0; j < 625; j = j + 1) begin


            // 15) 1110
            #1000 data_in = 4'b1110;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 1) 0000
            #1000;
            data_in = 4'b0000;
            total_count = total_count + 1; 
            
            if (data_out != last_data_in) error_count = error_count + 1; 
            last_data_in = data_in;

            // 2) 0001
            #1000;
            data_in = 4'b0001;
            total_count = total_count + 1;

            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 3) 0010
            #1000 data_in = 4'b0010;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 12) 1011
            #1000 data_in = 4'b1011;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 4) 0011
            #1000 data_in = 4'b0011;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 5) 0100
            #1000 data_in = 4'b0100;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 6) 0101
            #1000 data_in = 4'b0101;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 7) 0110
            #1000 data_in = 4'b0110;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 8) 0111
            #1000 data_in = 4'b0111;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 9) 1000
            #1000 data_in = 4'b1000;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 10) 1001
            #1000 data_in = 4'b1001;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 11) 1010
            #1000 data_in = 4'b1010;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;


            // 13) 1100
            #1000 data_in = 4'b1100;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;

            // 14) 1101
            #1000 data_in = 4'b1101;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;



            // 16) 1111
            #1000 data_in = 4'b1111;
            total_count = total_count + 1;
            if (data_out != last_data_in) error_count = error_count + 1;
            last_data_in = data_in;
        end

        #1000;
        $display("Error Count = %d, Total Count = %d, BER = %f",
                 error_count, total_count,
                 error_count*1.0 / total_count);
        
        $finish;
    end

endmodule
