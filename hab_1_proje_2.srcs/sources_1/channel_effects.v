`timescale 1ns / 1ps

module channel_effects(
input clk,
input [15:0]input_1,
output [15:0]output_1);

reg [15:0]noise;
integer noise_constant = 5000;
reg [15:0]temp;

always @(posedge clk) begin
            temp = input_1;
            noise = ($random % noise_constant) - (noise_constant/2);
            temp = temp + noise;
            
end
assign output_1 = temp;



endmodule
