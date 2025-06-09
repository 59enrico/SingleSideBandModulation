%% Leue, Enrico - MT/189104 - 09.06.2025
% --------------------------------------
% University of Applied Sciences Offenburg - Digital Signal Processing SS2025 - Single Sideband (SSB) modulation
% --------------------------------------
% This project implements the upper single sideband (SSB) modulation of an audio signal using the Hilbert transform and the phase method.
% The goal is to translate the frequency content of a given audio signal upwards by a variable amount in a generally real-time capable approach.
% The script loads an audio signal, computes its analytic signal using the Hilbert transform, and modulates it with a complex carrier signal.
% The spectra of both signals (original and modulated) are calculated and plotted to visualize the frequency shift.
% To demonstrate the effect of the modulation, both signals are also played back sequentially via speakers for comparison.

clear, close, clc                           % Clear workspace, close figures, clear command window.

%% Input audio signal
% Use a default MATLAB audio example file or delete the comment "%" on the line below and add custom file path
load train.mat;                             % MATLAB audio examples: chirp, gong, handel, laughter, splat, train.
% [y, Fs] = audioread("C:\myFolder\myCustomAudioFile.wav");
N = length(y);                              % Number of samples in the original file.
t = (0:N-1)/Fs;                             % [s] time vector corresponding to the original samples.

%% Modulation and carrier
Fc = 500;                                   % [Hz] Carrier frequency for modulation, equals frequency shift.
modulator = exp(1j*2*pi*Fc*t');             % Generate the complex exponential function (carrier) used for frequency translation of the input signal.

%% Windowing
y = y .* hann(N);                           % Windowing the signal reduces spectral leakage and prevents discontinuities (i.e. in bounderies of buffered real-time data).

%% Hilbert transform
y_hilbert = hilbert(y);                     % Compute the analytic signal form to isolate positive frequency components of signal, required for SSB modulation.

%% Single Sideband modulation
ssb = real(y_hilbert .* modulator);  % Upper SSB modulated signal is real part of the multiplication of the analytic signal with the complex carrier.

%% Calculate spectra
Y_fft = abs(fft(y, N));                     % Compute magnitude spectra of the original ...
SSB_fft = abs(fft(ssb, N));                 % ... and the SSB modulated signal for visualization.
f = linspace(0, Fs/2, floor(N/2)+1);        % Corresponding frequency vector up to Nyquist frequency.

%% Plot spectra and visualize shift
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


%% Speaker playback
t0 = 0;                                     % [s] Start of playback (changeable for custom files, for examples use 0).
dur = 5;                                    % [s] Duration of playback.
dur = min(dur, N/Fs);                       % Set maximum playback duration to signal length.
playtime = t0*Fs+1:(t0+dur)*Fs;             % Calculate the samples to be played back.
soundsc(y(playtime), Fs);                   % Playback the original signal.
pause(dur+1);                               % Pause between playbacks.
soundsc(ssb(playtime), Fs);                 % Playback the ssb signal.
