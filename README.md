# 16-8-4-2 Frequency-Shift Keying (FSK) Modulation and Demodulation on FPGA

This project demonstrates the implementation of Frequency-Shift Keying (FSK) modulation and demodulation on an FPGA. Below is an overview of the key modules and parameters used in the project.

# Modulation

The modulation process involves encoding the input data by varying the frequency of a carrier signal.

Parameters:

data_in: Input digital data to be transmitted.

sine_out, cos_out: Outputs of the modulator representing sine and cosine waveforms corresponding to the modulated signal.

![image](https://github.com/user-attachments/assets/14c27cfe-85c1-4c56-bace-96196a8af055)

## Channel Effects

This module simulates noise and distortion in the communication channel.

Gaussian Noise Parameters:

μ (mean): Set to 0 in this project.

σ (standard deviation): Controls the intensity of the noise.

Complex Noise: Simulated as a combination of real and imaginary parts (cosine and sine components).

Noise is generated using a Gaussian distribution (Box-Muller method) and added to the modulated signal.

The project uses separate real and imaginary noise components to mimic real-world channel effects.

![image](https://github.com/user-attachments/assets/5c87e81e-9434-4f44-887c-aec55662c051)

![image](https://github.com/user-attachments/assets/a51567c4-e87a-4b20-b281-f682c4fca050)

## Demodulation

The demodulator retrieves the transmitted data by analyzing the received noisy signal.

Parameters:

adc_in_sin, adc_in_cos: Inputs to the demodulator, representing the noisy sine and cosine signals.

data_out: Output representing the demodulated digital data.

Synchronization Threshold: A fixed threshold used to detect synchronization signals for starting the demodulation process.

![image](https://github.com/user-attachments/assets/7fa8a780-b143-4fa2-af77-d84e9f226891)

![image](https://github.com/user-attachments/assets/26d6ebb3-11bf-4a1e-92fd-2180a822f10c)

## Error Calculation

Bit Error Rate (BER) is calculated by comparing the transmitted and received data.

Parameters:

SNR (Signal-to-Noise Ratio): A key metric used to evaluate the performance.

Bits Sent: For accurate results, 10,000 and 100,000 bits are used in different experiments.

![image](https://github.com/user-attachments/assets/ef3e22a8-7a11-49b7-a754-a391830786ed)

## Results and Comparison

MATLAB vs FPGA: The BER curves from FPGA implementation closely resemble MATLAB simulations.

Limitations: Realistic channel effects (e.g., fading) are not included, causing deviations in certain SNR ranges.

## How to Run the Code

Clone the repository.

Load the Verilog files (modulation.v, channel_effects.v, demodulation.v, and testbench files) into your FPGA development environment (e.g., Vivado).

Run simulations and analyze the output.


