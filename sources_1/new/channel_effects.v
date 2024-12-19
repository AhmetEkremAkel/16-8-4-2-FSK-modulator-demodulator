`timescale 1ns / 1ps

module channel_effects(
input clk,
input signed  [16:0]input_1,
input signed  [16:0]input_2,
output signed [16:0]output_1,
output signed [16:0]output_2
);

reg signed [16:0]noise;
integer noise_constant = 24000;
reg signed [16:0]temp;
reg signed [16:0]temp_2;

initial begin
    $srandom($time); // Zamanı seed olarak kullan
end


always @(posedge clk) begin
    
            temp = input_1;
            noise = ($random % noise_constant) - (noise_constant/2);
            temp = temp + noise;
            temp <= { temp[15], temp};

            temp_2 = input_2;
            noise = ($random % noise_constant) - (noise_constant/2);
            temp_2 = temp_2 + noise;
            temp_2 <= { temp_2[15], temp_2};


end

assign output_1 = temp;
assign output_2 = temp_2;

endmodule
