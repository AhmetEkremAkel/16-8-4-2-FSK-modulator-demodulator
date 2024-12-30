`timescale 1ns / 1ps

module top_module(
input clk,
input reset,
input [2:0]data_in,
input start,
output [2:0]data_out
);

wire [17:0]wire_1;
wire [17:0]wire_2;
wire [17:0]wire_3;
wire [17:0]wire_4;
wire [17:0]wire_5;
wire [17:0]wire_6;


wire start_bit;
assign start_bit = start;

wire [17:0]wire_7;

assign wire_4 = wire_1;
assign wire_2 = wire_3;

assign wire_6 = wire_5;

fsk_modulator modulator_1(
.clk(clk),
.reset(reset),
.data_in(data_in),
.start(start_bit),
.sine_out(wire_1[17:0]),
.cos_out(wire_5[17:0])
);

channel_effects channel_1(
.clk(clk),
.input_1(wire_4[17:0]),
.input_2(wire_6),
.output_1(wire_3),
.output_2(wire_7)
);


fsk_demodulator demodulator_1(
.clk(clk),
.reset(reset),
.adc_in_sin(wire_2),
.adc_in_cos(wire_7),
.data_out(data_out)
);





endmodule