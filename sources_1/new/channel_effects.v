`timescale 1ns / 1ps

module channel_effects(
input clk,
input [15:0]input_1,
input [15:0]input_2,
output [15:0]output_1,
output [15:0]output_2
);

reg [15:0]noise;
integer noise_constant = 10000;
reg [15:0]temp;
reg [15:0]temp_2;

initial begin
    $srandom($time); // Zamanı seed olarak kullan
end


always @(posedge clk) begin
    
            temp = input_1;
            noise = ($random % noise_constant) - (noise_constant/2);
            temp = temp + noise;

            temp_2 = input_2;
            noise = ($random % noise_constant) - (noise_constant/2);
            temp_2 = temp_2 + noise;

end

assign output_1 = temp;
assign output_2 = temp_2;



endmodule
