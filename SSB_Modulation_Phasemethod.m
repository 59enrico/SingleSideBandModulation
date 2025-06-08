%% Leue, Enrico - MT/189104 - 05.06.2025
% --------------------------------------
% University of Applied Sciences Offenburg - Digital Signal Processing SS2025 - Project: Single Sideband (SSB) modulation
% --------------------------------------
% This project implements single sideband (SSB) modulation of an audio signal using the Hilbert transform and the phase method.
% The goal is to shift a given audio signal in frequency so that only the upper sideband remains.
% The script loads an audio signal, computes its analytic signal using the Hilbert transform, and modulates it with a carrier signal.
% The spectra of both the original and the SSB-modulated signals are then calculated and plotted to visualize the frequency shift.
% To demonstrate the effect of modulation, both signals can also be played back via speakers for direct comparison.

clear, close, clc

%% Input audio signal
% A) use matlab example file:
load handel.mat;                            % examples: chirp.mat (1.6 s), gong.mat (5.1 s), handel.mat (8.9 s), laughter.mat (6.4 s)
% B) use own file:
% [y, Fs] = audioread('...');
N = length(y);                              % [#] number of samples in the original audiofile
t = (0:N-1)/Fs;                             % [s] time vector of the original samples

%% Modulation and carrier
Fc = 200;                                   % [Hz] frequency by which the signal is modulated up
modulator = exp(1j*2*pi*Fc*t');             % complex sine function (carrier)

%% Windowing
y = y .* hann(N);                           % reduce spectral leakage and prevent discontinuities (i.e. in block bounderies of real time audio)

%% Hilbert transform
x_hilbert = hilbert(y);                     % analytic signal form to isolate positive frequencies of signal

%% Single Sideband modulation
ssb_signal = real(x_hilbert .* modulator);  % modulation by multiplication of signal with carrier

%% Calculate spectra
Y_fft = abs(fft(y, N));                     % fast fourier transform to get spectra of original signal ...
SSB_fft = abs(fft(ssb_signal, N));          % ... and SSB modulated signal
f = linspace(0, Fs/2, floor(N/2)+1);        % frequency vector from 0 to Nyquist-frequency of signal

%% Plot spectra and visualize shift
figure;
subplot(2,1,1);
plot(f/1e3, Y_fft(1:floor(N/2)+1), "LineWidth", 2, "DisplayName", 'Original signal');
hold on
plot(f/1e3, SSB_fft(1:floor(N/2)+1), "LineWidth", 2, "DisplayName", 'SSB signal');
title("Spectra of the signals, shifted up by: "+ num2str(Fc)+ " Hz.");
xlabel('Frequency [kHz]');
ylabel('Amplitude');
xlim([0 1]);                                % focus on the frequency shift in the lower frequencies
legend();

subplot(2,1,2);
plot(f/1e3, 20*log10(Y_fft(1:floor(N/2)+1)), "LineWidth", 2, "DisplayName", 'Original signal');
hold on
plot(f/1e3, 20*log10(SSB_fft(1:floor(N/2)+1)), "LineWidth", 2, "DisplayName", 'SSB signal');
title("Spectra of the signals in dB, shifted up by: "+ num2str(Fc)+ " Hz.");
xlabel('Frequency [kHz]');
ylabel('Amplitude [dB]');
xlim([0 1]);                                % focus on the frequency shift in the lower frequencies
legend();


%% Speaker playback
t0 = 0;                                     % [s] start of playback (i.e. 37 s)
dur = 5;                                    % [s] duration of playback (i.e. 8 s)
playtime = t0*Fs+1:(t0+dur)*Fs;             % calculate the samples to be played back
soundsc(y(playtime), Fs);                   % playback the original signal via speaker
pause(dur+1);                               % pause between playbacks
soundsc(ssb_signal(playtime), Fs);          % playback the ssb signal via speaker
