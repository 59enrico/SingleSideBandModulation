% Leue, Enrico - MT/189104 - 09.06.2025
% --------------------------------------
% University of Applied Sciences Offenburg - Digital Signal Processing SS2025 - Single Sideband (SSB) modulation
% --------------------------------------
% This project implements the upper single sideband (SSB) modulation of an audio signal using the Hilbert transform and the phase method.
% The goal is to translate the frequency content of a given audio signal upwards by a variable amount in a generally real-time capable approach.
% The script loads an audio signal, computes its analytic signal using the Hilbert transform, and modulates it with a complex carrier signal.
% The spectra of both signals (original and modulated) are calculated and plotted to visualize the frequency shift.
% To demonstrate the effect of the modulation, both signals are also played back sequentially via speakers for comparison.

% Clear workspace, close figures, clear command window.
clear, close, clc

% Input audio signal, use a default MATLAB audio example file or delete the comment "%" on the line below and add custom file path
load train.mat;
% [y, Fs] = audioread("C:\myFolder\myCustomAudioFile.wav");
% Number of samples in the original file.
N = length(y);
% Time vector corresponding to the original samples in seconds.
t = (0:N-1)/Fs;

% Carrier frequency representing the variable frequency shift in Hertz.
Fc = 500;
% Generate the complex exponential function (carrier) used for frequency translation of the input signal.
modulator = exp(1j*2*pi*Fc*t');

% Windowing the signal reduces spectral leakage and prevents discontinuities (i.e. in bounderies of buffered real-time data).
y = y .* hann(N);

% Hilbert transform the signal to compute the analytic signal form to isolate positive frequency components, which are required for SSB modulation.
y_hilbert = hilbert(y);

% Upper Single Sideband modulation is the real part of the multiplication of the analytic signal with the complex carrier.
ssb = real(y_hilbert .* modulator);

% Compute magnitude spectra of the original and the SSB modulated signal for visualization.
Y_fft = abs(fft(y, N));
SSB_fft = abs(fft(ssb, N));
% Corresponding frequency vector up to Nyquist frequency.
f = linspace(0, Fs/2, floor(N/2)+1);

% Plot both spectra to visualize modulation and frequency shift.
figure;
subplot(2,1,1);
plot(f/1e3, Y_fft(1:floor(N/2)+1), "LineWidth", 2, "DisplayName", "Original signal");
hold on
plot(f/1e3, SSB_fft(1:floor(N/2)+1), "LineWidth", 2, "DisplayName", "SSB signal");
title("Spectra of the signals, shifted up by: "+ num2str(Fc)+ " Hz.");
xlabel("Frequency [kHz]");
ylabel("Amplitude");
legend();

subplot(2,1,2);
plot(f/1e3, 20*log10(Y_fft(1:floor(N/2)+1)), "LineWidth", 2, "DisplayName", "Original signal");
hold on
plot(f/1e3, 20*log10(SSB_fft(1:floor(N/2)+1)), "LineWidth", 2, "DisplayName", "SSB signal");
title("Spectra of the signals in dB, shifted up by: "+ num2str(Fc)+ " Hz.");
xlabel("Frequency [kHz]");
ylabel("Amplitude [dB]");
legend();

% Speaker playback to hear the frequency shift between the original audio signal to the SSB modulated signal
% Start of playback in seconds (default and examples: 0).
t0 = 0;
% Duration of playback in seconds.
dur = 5;
% Set maximum playback duration to signal length.
dur = min(dur, N/Fs);                       
% Calculate the samples to be played back.
playtime = t0*Fs+1:(t0+dur)*Fs;             
% Playback the original signal.
soundsc(y(playtime), Fs);                   
% Pause between playbacks.
pause(dur+1);
% Playback the ssb signal.
soundsc(ssb(playtime), Fs);