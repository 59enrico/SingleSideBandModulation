%% Leue, Enrico - MT/189104 - 05.06.2025
% --------------------------------------
% Digital Signalprocessing SS2025 - Project: Single Sideband (SSB) modulation
% This Script modulates a given audiosignal using the Hilbert transform and the phasemethod to get the upper Sigle Sideband (SSB) modulation of the signal. 
% To view and hear the effects of the SSB modulation, the spectra of both signals (original and modulated) are plotted and a short excerpt from both
% is played via speaker.

clear, close, clc

%% Input audiosignal
[x, Fs] = audioread('/Users/enrico/Documents/hochschule_offenburg/MT8/Digitale_Signalverarbeitung/Kap2/LEnfantSauvage-96k.ogg');
N = length(x);                              % [#] number of samples in the original audiofile
t = (0:N-1)/Fs;                             % [s] time vector of the original samples

%% Modulation and carrier
Fc = 200;                                   % [Hz] frequency by which the signal is modulated up
modulator = exp(1j*2*pi*Fc*t');             % complex sine function (carrrier)

%% Hilbert transform
x_hilbert = hilbert(x);                     % analytic signal form to isolate positive frequencies of signal

%% Single Sideband modulation
ssb_signal = real(x_hilbert .* modulator);  % modulation by multiplication of signal with carrier

%% Calculate spectra
X_fft = abs(fft(x, N));                     % fast fourier transform to get spectra of original signal ...
SSB_fft = abs(fft(ssb_signal, N));          % ... and SSB modulated signal
f = linspace(0, Fs/2, floor(N/2)+1);        % frequency vector from 0 to Nyquist-frequency of signal

%% Plot spectra and visualize shift
figure;
subplot(2,1,1);
plot(f/1e3, X_fft(1:floor(N/2)+1), "LineWidth", 2, "DisplayName", 'Original signal');
hold on
plot(f/1e3, SSB_fft(1:floor(N/2)+1), "LineWidth", 2, "DisplayName", 'SSB signal');
title("Spectra of the signals, shifted up by: "+ num2str(Fc)+ " Hz.");
xlabel('Frequency [kHz]');
ylabel('Amplitude');
xlim([0 1]);                                % focus on the frequency shift in the lower frequencies
legend();

subplot(2,1,2);
plot(f/1e3, 20*log10(X_fft(1:floor(N/2)+1)), "LineWidth", 2, "DisplayName", 'Original signal');
hold on
plot(f/1e3, 20*log10(SSB_fft(1:floor(N/2)+1)), "LineWidth", 2, "DisplayName", 'SSB signal');
title("Spectra of the signals in dB, shifted up by: "+ num2str(Fc)+ " Hz.");
xlabel('Frequency [kHz]');
ylabel('Amplitude [dB]');
xlim([0 1]);                                % focus on the frequency shift in the lower frequencies
legend();


%% Speaker playback
t0 = 37;                                    % [s] start of playback (i.e. 37 s)
dur = 8;                                    % [s] duration of playback (i.e. 8 s)
playtime = t0*Fs:(t0+dur)*Fs;               % calculate the samples to be played back
soundsc(x(playtime), Fs);                   % playback the original signal via speaker
pause(dur+1);
soundsc(ssb_signal(playtime), Fs);          % playback the ssb signal via speaker
