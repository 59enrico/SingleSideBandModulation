%% Leue, Enrico - MT/189104 - 05.06.2025
% --------------------------------------
% Digitale Signalverarbeitung SS2025 - Projektarbeit Einseitenbandmodulation (ESB):
% Mittels Hilbert-Transformation und Phasenmethode wird eine Audiodatei um eine gewünschte Modulationsfrequnz nach oben verschoben

clear, close, clc

%% Audiodatei
[x, Fs] = audioread('/Users/enrico/Documents/hochschule_offenburg/MT8/Digitale_Signalverarbeitung/Kap2/LEnfantSauvage-96k.ogg');
N = length(x);          % [#] Anzahl der Samples der originalen Audioadatei
t = (0:N-1)/Fs;         % [s] Zeitvektor

%% Modulationsfrequenz
Fc = 200;               % [Hz] Frequenzverschiebung nach oben (< 1 kHz)

%% Hilbert-Transformation
x_hilbert = hilbert(x); % analytische Signalform

%% Einseitenbandmodulation
ssb_signal = real(x_hilbert .* exp(1j*2*pi*Fc*t')); 

%% Spektren berechnen
X_fft = abs(fft(x, N));
SSB_fft = abs(fft(ssb_signal, N));
f = linspace(0, Fs/2, floor(N/2)+1);

%% Spektren visualisieren
figure;
subplot(2,1,1);
plot(f/1e3, X_fft(1:floor(N/2)+1), "LineWidth", 2, "DisplayName", 'Original Signal');
hold on
plot(f/1e3, SSB_fft(1:floor(N/2)+1), "LineWidth", 2, "DisplayName", 'SSB Signal');
title('Spektren der Signale');
xlabel('Frequenz [kHz]');
ylabel('Amplitude');
xlim([0 1]);
legend();

subplot(2,1,2);
plot(f/1e3, 20*log10(X_fft(1:floor(N/2)+1)), "LineWidth", 2, "DisplayName", 'Original Signal');
hold on
plot(f/1e3, 20*log10(SSB_fft(1:floor(N/2)+1)), "LineWidth", 2, "DisplayName", 'SSB Signal');
title('Spektren der Signale in dB');
xlabel('Frequenz [kHz]');
ylabel('Amplitude [dB]');
xlim([0 1]);
legend();


%% Lautsprecherwiedergabe des modifizierten Signals
t0 = 37;                            % [s] Startpunkt der Wiedergabe (bspw. 37)
dur = 8;                            % [s] Dauer der Wiedergabe (bspw. 8)
playtime = t0*Fs:(t0+dur)*Fs;       % Berechnung der zu wiedergebenden Samples
sound(x(playtime), Fs);             % Wiedergabe Ausschnitt Original Signal
pause(dur+1);
sound(ssb_signal(playtime), Fs);    % Wiedergabe Ausschnitt ESB Signal

